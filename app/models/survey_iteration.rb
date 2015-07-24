require "google/api_client"
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require "google_drive"
require 'survey-gizmo-ruby'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class SurveyIteration < ActiveRecord::Base
  OAUTH_CALLBACK_URI = 'https://www.example.com/oauth2callback'
  SPREADSHEET_ID  = '1R0X0L9ouA9ZQl6lowXGJBlc5HbU6VHmGULb9dPKfcNM'
  WORKSHEET_TITLE = 'Art Submissions (updated)'

  serialize :worksheet_header_row

  has_many :survey_pages
  has_many :survey_questions, :through => :survey_pages

  before_validation :ensure_title_set
  before_validation :import_questions_from_google!

  validates_presence_of :title

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
  def self.obtain_google_drive_session(code=nil)
    begin
      obtain_google_drive_session!
    rescue GoogleAuthRequiredError
      auth = build_google_auth_obj
      if code.nil?
        print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
        print("2. Enter the authorization code shown in the page: ")
        code = $stdin.gets.chomp
      end
      do_google_auth_with_code! code, auth
      obtain_google_drive_session!
    end
  end
  def self.obtain_google_drive_session!(return_auth_uri=false)
    fetch_google_tokens_from_cache
    raise GoogleAuthRequiredError.new unless @@google_access_token

    # Creates a session.
    begin
      @@gd_session = GoogleDrive.login_with_oauth @@google_access_token
    rescue Google::APIClient::AuthorizationError
      clear_google_tokens!
      # obtain_google_drive_session!
      raise GoogleAuthRequiredError.new
    end
  end
  def self.build_google_auth_obj
    client = Google::APIClient.new
    auth = client.authorization
    auth.client_id = Rails.application.secrets.google_client_id
    auth.client_secret = Rails.application.secrets.google_client_secret
    auth.redirect_uri = Rails.application.secrets.google_callback_uri || 
                        OAUTH_CALLBACK_URI
    auth.scope = [
      "https://www.googleapis.com/auth/drive",
      "https://spreadsheets.google.com/feeds/" # ,
      # "email", "profile"
    ]
    # auth.additional_parameters = {'access_type' => 'offline'}
    auth
  end
  def self.do_google_auth_with_code!(code, auth=nil)
    auth ||= build_google_auth_obj
    auth.code = code
    # get_google_tokens_from_code! code
    auth.fetch_access_token!
    return false unless auth.access_token.present?

    @@google_access_token = auth.access_token
    @@google_auth_expires_at = auth.expires_at

    write_google_tokens_to_cache!
    true
  end

  def self.google_sheet
    begin
      self.google_drive_session.spreadsheet_by_key SPREADSHEET_ID
    rescue Google::APIClient::AuthorizationError, Google::APIClient::ClientError
      self.clear_google_tokens!
      self.obtain_google_drive_session!
      self.google_sheet
    end
  end

  def self.google_worksheet
    self.google_sheet.worksheets.find{|ws| ws.title == WORKSHEET_TITLE }
  end

  def import_questions_from_google!
    rows = self.class.google_worksheet.rows
    self.worksheet_header_row = rows.first
    rows[1..-1].each do |cells|
      cell_hash = {}
      cells.each_with_index do |cell, i|
        heading = self.worksheet_header_row[i]
        cell_hash[heading] = cell
      end
      self.survey_pages.build :metadata => cell_hash
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
    puts 'Exporting survey!'
    survey = SurveyGizmo::API::Survey.create self.sg_survey_params
    if self.new_record?
      self.sg_survey_id = survey.id
      self.publish_to_sg_started_at = Time.now
    else
      self.update_column(:sg_survey_id, survey.id)
      self.update_column(:publish_to_sg_started_at, Time.now)
    end
    self.survey_pages.select{|sp| sp.metadata['week'] == 'Week 1.5' }
                     .each(&:export_to_survey_gizmo!)
    self.published_to_sg_at = Time.now
    return true if self.new_record?
    self.save!
  end
  def delete_from_survey_gizmo!
    return false unless self.sg_survey_id.present?
    self.sg_survey.destroy
    return true if self.new_record?
    self.save!
  end

  def self.publish_from_google_drive!(attrs={})
    instance = new attrs
    instance.send :ensure_title_set
    puts "Publishing #{ instance.title }"
    instance.export_to_survey_gizmo!
    puts
    puts "SurveyGizmo export complete!"
    puts "Edit URL: #{instance.sg_survey.links['edit']}"
    puts
    instance
  end

  def queued_for_publishing?
    publish_to_sg_queued_at.present? && !publishing_to_sg?; end
  def publishing_to_sg?
    publish_to_sg_started_at.present? && !published_to_sg?; end
  def published_to_sg?; self.published_to_sg_at.present?; end

  def publish_to_sg!
    # self.published_to_sg_at = Time.now
    self.publish_to_sg_queued_at = Time.now
    # return false unless export_to_survey_gizmo!
    return false unless self.save
    PublishToSgJob.perform_later self
    true
  end
  def delete_from_sg!
    return false unless delete_from_survey_gizmo!
    self.published_to_sg_at = nil
    self.save
  end

  def status
    return 'Published' if published_to_sg?
    return 'Publishing' if publishing_to_sg?
    return 'Queued for Publishing' if queued_for_publishing?
    'Not Published'
  end

  class GoogleAuthRequiredError < StandardError
    # attr_reader :auth_uri
    # def initialize(auth_uri); @auth_uri = auth_uri; end
    def message; "Google authorization is required."; end
  end

  private
  def ensure_title_set
    self.title ||= "Kollecto Survey #{Time.now.to_s}"
  end

end
