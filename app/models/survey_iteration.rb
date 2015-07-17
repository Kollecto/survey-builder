require "google/api_client"
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require "google_drive"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class SurveyIteration < ActiveRecord::Base
  OAUTH_CALLBACK_URL = 'https://www.example.com/oauth2callback'
  SPREADSHEET_ID = '1R0X0L9ouA9ZQl6lowXGJBlc5HbU6VHmGULb9dPKfcNM'
  WORKSHEET_INDEX = 0

  has_many :survey_questions

  @@gd_session = nil
  @@google_access_token = nil
  @@google_refresh_token = nil
  @@google_auth_expires_at = nil

  def self.google_integration_activated?
    @@google_access_token.present? && @@google_refresh_token.present?
  end

  def self.google_client
    return nil unless google_integration_activated?
    client = Google::APIClient.new :application_name => 'My Project',
                                   :application_version => '1.0.0'
    client.authorization.access_token = @@google_access_token
    plus_api = client.discovered_api('plus', 'v1')
    response = client.execute(
        :api_method => plus_api.people.get,
        :parameters => {'userId' => 'me'}
    )
    @@google_profile_cache = JSON.parse(response.body)
    if @@google_profile_cache.key?('error') &&
       @@google_profile_cache['error']['code'] == 401
      self.refresh_google_client!
      return google_client
    end
    client
  end

  def self.refresh_google_client!
    puts 'refreshing google client!'
    conn = Faraday.new :url => 'https://accounts.google.com', :ssl => {:verify => false} do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
    result = conn.post '/o/oauth2/token', {
      'client_id' => Rails.application.secrets.google_client_id,
      'client_secret' => Rails.application.secrets.google_client_secret,
      'refresh_token' => @@google_refresh_token,
      'grant_type' => 'refresh_token' }
    response = JSON.parse(result.body)
    puts response.inspect
    @@google_access_token = response['access_token'] if response.key?('access_token')
    if response.key?('expires_in')
      @@google_auth_expires_at = Time.now + response['expires_in'].to_i.seconds
    end
    true
  end

  def self.get_google_tokens_from_code!(code)
    conn = Faraday.new :url => 'https://accounts.google.com',
              :ssl => {:verify => false} do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
    result = conn.post '/o/oauth2/token', {
        'code' => code,
        'client_id' => Rails.application.secrets.google_client_id,
        'client_secret' => Rails.application.secrets.google_client_secret,
        'redirect_uri' => OAUTH_CALLBACK_URL,
        'grant_type' => 'authorization_code'
    }
    begin
      response = JSON.parse(result.body)
      puts response
      if response.key?('access_token') && response.key?('refresh_token')
        @@google_access_token = response['access_token']
        @@google_refresh_token = response['refresh_token']
        @@google_auth_expires_at = Time.now + response['expires_in'].to_i.seconds
        puts 'Tokens obtained successfully!'
      else
        puts 'Bad response received from Google.'
      end
    rescue JSON::ParserError
      puts 'Bad response received from Google.'
    end
  end

  def self.google_profile
    return @@google_profile_cache if google_integration_activated? && @@google_profile_cache.present?
    google_client
    @@google_profile_cache
  end


  def self.google_drive_session
    return @@gd_session if @@gd_session.present?
    puts 'obtaining new session!'
    obtain_google_drive_session!
  end
  def self.obtain_google_drive_session!
    # Authorizes with OAuth and gets an access token.
    unless @@google_access_token
      client = Google::APIClient.new
      auth = client.authorization
      auth.client_id = Rails.application.secrets.google_client_id
      auth.client_secret = Rails.application.secrets.google_client_secret
      auth.scope = [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/" # ,
        # "email", "profile"
      ]
      # auth.additional_parameters = {'access_type' => 'offline'}
      auth.redirect_uri = OAUTH_CALLBACK_URL
      print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
      print("2. Enter the authorization code shown in the page: ")
      code = $stdin.gets.chomp
      puts "Code: #{code}"
      auth.code = code
      auth.fetch_access_token!
      @@google_access_token = auth.access_token
    end
    # get_google_tokens_from_code! code
    # refresh_google_client!

    # Creates a session.
    @@gd_session = GoogleDrive.login_with_oauth @@google_access_token
  end

  def self.google_sheet
    self.google_drive_session.spreadsheet_by_key(SPREADSHEET_ID)
  end

  def self.google_worksheet
    self.google_sheet.worksheets[WORKSHEET_INDEX]
  end

  def import_questions_from_google!
    rows = self.class.google_worksheet.rows
    header_row = rows.first
    rows[1..-1].each do |cells|
      cell_hash = {}
      cells.each_with_index do |cell, i|
        heading = header_row[i]
        cell_hash[heading] = cell
      end
      q = SurveyQuestion.new(:metadata => cell_hash)
      puts q.inspect
      self.survey_questions << q
    end
    true
  end

end
