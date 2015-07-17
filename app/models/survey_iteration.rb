require "google/api_client"
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require "google_drive"
require 'survey-gizmo-ruby'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class SurveyIteration < ActiveRecord::Base
  OAUTH_CALLBACK_URL = 'https://www.example.com/oauth2callback'
  SPREADSHEET_ID = '1R0X0L9ouA9ZQl6lowXGJBlc5HbU6VHmGULb9dPKfcNM'
  WORKSHEET_INDEX = 0

  has_many :survey_questions
  after_initialize :import_questions_from_google!

  @@gd_session = nil
  @@google_access_token = nil
  # @@google_refresh_token = nil
  @@google_auth_expires_at = nil

  def self.google_integration_activated?
    @@google_access_token.present? # && @@google_refresh_token.present?
  end

  def self.fetch_google_tokens_from_cache
    @@google_access_token    ||= Rails.cache.read 'google_access_token'
    @@google_auth_expires_at ||= Rails.cache.read 'google_auth_expires_at'
    # @@google_refresh_token ||= Rails.cache.read 'google_refresh_token'
  end
  def self.write_google_tokens_to_cache!
    return unless google_integration_activated?
    Rails.cache.write 'google_access_token',    @@google_access_token
    # Rails.cache.write 'google_refresh_token', @@google_refresh_token
    Rails.cache.write 'google_auth_expires_at', @@google_auth_expires_at
  end
  def self.clear_google_tokens!
    @@google_access_token = nil
    @@google_auth_expires_at = nil
    Rails.cache.write 'google_access_token', nil
    Rails.cache.write 'google_auth_expires_at', nil
  end

  # def self.get_google_tokens_from_code!(code)
  #   conn = Faraday.new :url => 'https://accounts.google.com',
  #             :ssl => {:verify => false} do |faraday|
  #     faraday.request :url_encoded
  #     faraday.response :logger
  #     faraday.adapter Faraday.default_adapter
  #   end
  #   result = conn.post '/o/oauth2/token', {
  #       'code' => code,
  #       'client_id' => Rails.application.secrets.google_client_id,
  #       'client_secret' => Rails.application.secrets.google_client_secret,
  #       'redirect_uri' => OAUTH_CALLBACK_URL,
  #       'grant_type' => 'authorization_code'
  #   }
  #   begin
  #     response = JSON.parse(result.body)
  #     puts response
  #     if response.key?('access_token') && response.key?('refresh_token')
  #       @@google_access_token = response['access_token']
  #       @@google_refresh_token = response['refresh_token']
  #       @@google_auth_expires_at = Time.now + response['expires_in'].to_i.seconds
  #       puts 'Tokens obtained successfully!'
  #     else
  #       puts 'Bad response received from Google.'
  #     end
  #   rescue JSON::ParserError
  #     puts 'Bad response received from Google.'
  #   end
  # end

  def self.google_drive_session
    return @@gd_session if @@gd_session.present?
    obtain_google_drive_session!
  end
  def self.obtain_google_drive_session!
    fetch_google_tokens_from_cache

    unless @@google_access_token
      # Authorizes with OAuth and gets an access token.
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
      auth.code = code
      # get_google_tokens_from_code! code
      auth.fetch_access_token!
      @@google_access_token = auth.access_token
      @@google_auth_expires_at = auth.expires_at

      write_google_tokens_to_cache!
    end

    # Creates a session.
    @@gd_session = GoogleDrive.login_with_oauth @@google_access_token
  end

  def self.google_sheet
    self.google_drive_session.spreadsheet_by_key SPREADSHEET_ID
  end

  def self.google_worksheet
    self.google_sheet.worksheets[ WORKSHEET_INDEX ]
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
      # self.survey_questions << SurveyQuestion.new(:metadata => cell_hash)
      self.survey_questions.build :metadata => cell_hash
    end
    true
  end

  def sg_survey
    return unless self.sg_survey_id.present?
    SurveyGizmo::API::Survey.first id: self.sg_survey_id
  end
  def sg_survey_params
    {
      :title => self.title,
      :type => 'survey',
      :team => '611296',
      :status => 'launched'
    }
  end

  def export_to_survey_gizmo!
    survey = SurveyGizmo::API::Survey.create self.sg_survey_params
    self.sg_survey_id = survey.id
    self.survey_questions.each(&:export_to_survey_gizmo!)
  end

  def delete_from_survey_gizmo!
    return false unless self.sg_survey_id.present?
    self.sg_survey.destroy
  end

end
