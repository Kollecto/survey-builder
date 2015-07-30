require 'survey-gizmo-ruby'

class SurveyIteration < ActiveRecord::Base
  # OAUTH_CALLBACK_URI = 'https://www.example.com/oauth2callback'
  # SPREADSHEET_ID  = '1R0X0L9ouA9ZQl6lowXGJBlc5HbU6VHmGULb9dPKfcNM'
  # WORKSHEET_TITLE = 'Art Submissions (updated)'

  attr_accessor :google_worksheet_params
  serialize :worksheet_header_row

  belongs_to :creator, class_name: 'User'
  has_many :survey_pages, :dependent => :destroy
  has_many :survey_questions, :through => :survey_pages
  has_many :survey_submissions

  before_validation :ensure_title_set
  before_validation :process_google_worksheet_params
  after_commit :begin_import_from_google!, :if => :ready_to_import_from_google?

  validates_presence_of :title

  # @@gd_session = nil
  # @@google_access_token = nil
  # # @@google_refresh_token = nil
  # @@google_auth_expires_at = nil
  #
  # def self.google_integration_activated?
  #   @@google_access_token.present? # && @@google_refresh_token.present?
  # end
  #
  # def self.fetch_google_tokens_from_cache
  #   @@google_access_token    ||= Rails.cache.read 'google_access_token'
  #   @@google_auth_expires_at ||= Rails.cache.read 'google_auth_expires_at'
  #   # @@google_refresh_token ||= Rails.cache.read 'google_refresh_token'
  # end
  # def self.write_google_tokens_to_cache!
  #   return unless google_integration_activated?
  #   Rails.cache.write 'google_access_token',    @@google_access_token
  #   # Rails.cache.write 'google_refresh_token', @@google_refresh_token
  #   Rails.cache.write 'google_auth_expires_at', @@google_auth_expires_at
  # end
  # def self.clear_google_tokens!
  #   @@google_access_token = nil
  #   @@google_auth_expires_at = nil
  #   Rails.cache.write 'google_access_token', nil
  #   Rails.cache.write 'google_auth_expires_at', nil
  # end
  #
  # # def self.get_google_tokens_from_code!(code)
  # #   conn = Faraday.new :url => 'https://accounts.google.com',
  # #             :ssl => {:verify => false} do |faraday|
  # #     faraday.request :url_encoded
  # #     faraday.response :logger
  # #     faraday.adapter Faraday.default_adapter
  # #   end
  # #   result = conn.post '/o/oauth2/token', {
  # #       'code' => code,
  # #       'client_id' => Rails.application.secrets.google_client_id,
  # #       'client_secret' => Rails.application.secrets.google_client_secret,
  # #       'redirect_uri' => OAUTH_CALLBACK_URL,
  # #       'grant_type' => 'authorization_code'
  # #   }
  # #   begin
  # #     response = JSON.parse(result.body)
  # #     puts response
  # #     if response.key?('access_token') && response.key?('refresh_token')
  # #       @@google_access_token = response['access_token']
  # #       @@google_refresh_token = response['refresh_token']
  # #       @@google_auth_expires_at = Time.now + response['expires_in'].to_i.seconds
  # #       puts 'Tokens obtained successfully!'
  # #     else
  # #       puts 'Bad response received from Google.'
  # #     end
  # #   rescue JSON::ParserError
  # #     puts 'Bad response received from Google.'
  # #   end
  # # end
  #
  # def self.google_drive_session
  #   return @@gd_session if @@gd_session.present?
  #   obtain_google_drive_session!
  # end
  # def self.obtain_google_drive_session(code=nil)
  #   begin
  #     obtain_google_drive_session!
  #   rescue GoogleAuthRequiredError
  #     auth = build_google_auth_obj
  #     if code.nil?
  #       print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
  #       print("2. Enter the authorization code shown in the page: ")
  #       code = $stdin.gets.chomp
  #     end
  #     do_google_auth_with_code! code, auth
  #     obtain_google_drive_session!
  #   end
  # end
  # def self.obtain_google_drive_session!(return_auth_uri=false)
  #   fetch_google_tokens_from_cache
  #   raise GoogleAuthRequiredError.new unless @@google_access_token
  #
  #   # Creates a session.
  #   begin
  #     @@gd_session = GoogleDrive.login_with_oauth @@google_access_token
  #   rescue Google::APIClient::AuthorizationError
  #     clear_google_tokens!
  #     # obtain_google_drive_session!
  #     raise GoogleAuthRequiredError.new
  #   end
  # end
  # def self.build_google_auth_obj
  #   client = Google::APIClient.new
  #   auth = client.authorization
  #   auth.client_id = Rails.application.secrets.google_client_id
  #   auth.client_secret = Rails.application.secrets.google_client_secret
  #   auth.redirect_uri = Rails.application.secrets.google_callback_uri || 
  #                       OAUTH_CALLBACK_URI
  #   auth.scope = [
  #     "https://www.googleapis.com/auth/drive",
  #     "https://spreadsheets.google.com/feeds/" # ,
  #     # "email", "profile"
  #   ]
  #   # auth.additional_parameters = {'access_type' => 'offline'}
  #   auth
  # end
  # def self.do_google_auth_with_code!(code, auth=nil)
  #   auth ||= build_google_auth_obj
  #   auth.code = code
  #   # get_google_tokens_from_code! code
  #   auth.fetch_access_token!
  #   return false unless auth.access_token.present?
  #
  #   @@google_access_token = auth.access_token
  #   @@google_auth_expires_at = auth.expires_at
  #
  #   write_google_tokens_to_cache!
  #   true
  # end
  #
  # def self.google_sheet
  #   begin
  #     self.google_drive_session.spreadsheet_by_key SPREADSHEET_ID
  #   rescue Google::APIClient::AuthorizationError, Google::APIClient::ClientError
  #     self.clear_google_tokens!
  #     self.obtain_google_drive_session!
  #     self.google_sheet
  #   end
  # end
  #
  # def self.google_worksheet
  #   self.google_sheet.worksheets.find{|ws| ws.title == WORKSHEET_TITLE }
  # end

  def has_google_worksheet?
    google_spreadsheet_id.present? && google_worksheet_url.present?
  end

  def google_spreadsheet
    return if self.google_spreadsheet_id.nil?
    self.creator.google_spreadsheets.find{|ss|
             self.google_spreadsheet_id == ss.id }
  end
  def google_worksheet
    return if self.google_spreadsheet_id.nil? || self.google_worksheet_url.nil?
    self.google_spreadsheet.worksheets.find{|ws|
                self.google_worksheet_url == ws.worksheet_feed_url }
  end

  def art_attribute_columns
    return [] if !has_google_worksheet? || preparing_to_import_from_google?
    start_index = self.google_worksheet_art_attributes_start_column_index || 14
    end_index = self.google_worksheet_art_attributes_end_column_index || -1
    self.worksheet_header_row[start_index..end_index]
  end

  def import_questions_from_google
    return false unless has_google_worksheet?
    puts 'Importing from Google!'
    ws = self.google_worksheet
    return false if ws.nil?
    update_column :import_from_google_started_at, Time.now
    rows = ws.rows
    update_column :worksheet_header_row, rows[google_worksheet_header_row_index]
    rows[(google_worksheet_header_row_index + 1)..-1].each do |cells|
      cell_hash = {}
      cells.each_with_index do |cell, i|
        heading = self.worksheet_header_row[i]
        cell_hash[heading] = cell
      end
      if import_filter_specified?
        relevant_value = cell_hash[self.import_filtering_column]
        next unless google_worksheet_filtering_column_value == relevant_value
      end
      self.survey_pages.build :metadata => cell_hash,
                :imported_from_google_at => Time.now
    end
    # update_column :import_from_google_completed_at, Time.now
    true
  end
  def import_questions_from_google!
    return false unless import_questions_from_google
    # puts "Length there: #{self.survey_pages.length}"
    self.import_from_google_completed_at = Time.now
    save!
  end
  def begin_import_from_google!
    self.update_columns(
      :import_from_google_queued_at => Time.now,
      :import_from_google_started_at => nil,
      :import_from_google_completed_at => nil )
    # return false unless self.save
    job = ImportFromGoogleDriveJob.perform_later self
    self.update_column :import_from_google_jid, job.job_id
    true
  end
  def begin_reimport_from_google!
    self.survey_pages.imported_from_google.destroy_all
    self.begin_import_from_google!
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
      self.delete_from_sg_queued_at = nil
      self.delete_from_sg_started_at = nil
      self.delete_from_sg_completed_at = nil
      self.publish_to_sg_started_at = Time.now
    else
      self.update_columns :sg_survey_id => survey.id,
                          :publish_to_sg_started_at => Time.now,
                          :delete_from_sg_queued_at => nil,
                          :delete_from_sg_started_at => nil,
                          :delete_from_sg_completed_at => nil
    end
    self.survey_pages.each(&:export_to_survey_gizmo!)
    return false if self.reload.publish_to_sg_cancelled?
    self.published_to_sg_at = Time.now
    return true if self.new_record?
    self.save!
  end
  def delete_from_survey_gizmo!
    return false unless self.sg_survey_id.present?
    puts "Deleting #{title} from Survey Gizmo!"
    update_column :delete_from_sg_started_at, Time.now
    self.survey_pages.published_to_sg.each(&:delete_from_survey_gizmo!)
    self.sg_survey.destroy
    self.delete_from_sg_completed_at = Time.now
    self.published_to_sg_at = nil
    self.publish_to_sg_started_at = nil
    self.publish_to_sg_queued_at = nil
    self.publish_to_sg_cancelled_at = nil
    self.sg_survey_id = nil
    return true if new_record?
    self.save!
  end

  def self.publish_from_google_drive_without_saving!(attrs={})
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

  def should_import_from_google?
    has_google_worksheet? && 
      !importing_from_google? && !import_from_google_queued?; end
  def ready_to_import_from_google?
    should_import_from_google? && google_worksheet_header_row_index.present? &&
      google_worksheet_art_attributes_start_column_index.present? &&
      google_worksheet_art_attributes_end_column_index.present?; end
  def preparing_to_import_from_google?
    should_import_from_google? && !ready_to_import_from_google?; end

  def import_filter_specified?
    google_worksheet_filtering_column_index.present? &&
      google_worksheet_filtering_column_value.present?
  end
  def import_filtering_column
    return unless worksheet_header_row.present? && import_filter_specified?
    worksheet_header_row[google_worksheet_filtering_column_index]
  end

  def imported_from_google?; import_from_google_completed_at.present?; end
  def importing_from_google?
    !imported_from_google? && import_from_google_started_at.present?; end
  def import_from_google_queued?
    !importing_from_google? && import_from_google_completed_at.present?; end
  def import_from_google_failed?; import_from_google_failed_at.present?; end
  def mark_import_from_google_failed!
    update_column :import_from_google_failed_at, Time.now; end

  def publish_to_sg_cancelled?; publish_to_sg_cancelled_at.present?; end
  def publish_to_sg_queued?
    publish_to_sg_queued_at.present? &&
      !publishing_to_sg? && !publish_to_sg_cancelled?; end
  def publishing_to_sg?
    publish_to_sg_started_at.present? &&
      !published_to_sg? && !publish_to_sg_cancelled?; end
  def published_to_sg?; self.published_to_sg_at.present?; end

  def delete_from_sg_queued?
    !deleting_from_sg? && !deleted_from_sg? &&
      delete_from_sg_queued_at.present?; end
  def deleting_from_sg?
    !deleted_from_sg? && delete_from_sg_started_at.present?; end
  def deleted_from_sg?; delete_from_sg_completed_at.present?; end

  def publish_to_sg!
    self.publish_to_sg_queued_at = Time.now
    self.publish_to_sg_started_at = nil
    self.publish_to_sg_cancelled_at = nil
    self.published_to_sg_at = nil
    # return false unless export_to_survey_gizmo!
    return false unless self.save
    job = PublishToSgJob.perform_later self
    update_column :sg_publishing_jid, job.job_id
    true
  end
  def cancel_publish_to_sg!
    return false unless publishing_to_sg?
    update_column :publish_to_sg_cancelled_at, Time.now
    # self.publish_to_sg_cancelled_at = Time.now
    # return false unless self.save
    PublishToSgJob.cancel! self.sg_publishing_jid
    true
  end
  def delete_from_sg!
    self.delete_from_sg_queued_at = Time.now
    return false unless self.save
    job = DeleteFromSgJob.perform_later self
    update_column :delete_from_sg_jid, job.job_id
    true
  end

  def queued_for_deletion?; deletion_queued_at.present? && !being_deleted?; end
  def being_deleted?;    !deletion_failed? && deletion_started_at.present?; end
  def deletion_pending?;            queued_for_deletion? || being_deleted?; end
  def deletion_failed?;                        deletion_failed_at.present?; end

  def sg_status
    return 'Deleting' if deleting_from_sg?
    return 'Queued for Deletion' if delete_from_sg_queued?
    return 'Published' if published_to_sg?
    return 'Publishing' if publishing_to_sg?
    return 'Cancelled Publishing' if publish_to_sg_cancelled?
    return 'Queued for Publishing' if publish_to_sg_queued?
    'Not Published'
  end

  def gd_status
    return 'Imported' if imported_from_google?
    return 'Importing' if importing_from_google?
    return 'Failed to Import' if import_from_google_failed?
    return 'Queued for Import' if import_from_google_queued?
    'Not Imported'
  end

  class GoogleAuthRequiredError < StandardError
    # attr_reader :auth_uri
    # def initialize(auth_uri); @auth_uri = auth_uri; end
    def message; "Google authorization is required."; end
  end

  def self.default_title; "Kollecto Survey #{Time.now.to_s}"; end

  private
  def ensure_title_set
    self.title = self.class.default_title if self.title.blank?
  end
  def process_google_worksheet_params
    if self.google_worksheet_params.present?
      self.google_spreadsheet_id, self.google_worksheet_url =
        self.google_worksheet_params.split(' | ')
    end
    # if self.google_worksheet_header_row_index_changed?
    # end
  end

end
