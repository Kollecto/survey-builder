class User < ActiveRecord::Base
  DEFAULT_OAUTH_CALLBACK_URI = 'https://www.example.com/oauth2callback'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w( User Admin )

  attr_accessor :taste_category_name, :google_drive_session_cache

  has_many :survey_submissions
  has_many :survey_iterations_created, class_name: 'SurveyIteration',
            foreign_key: :creator_id
  has_and_belongs_to_many :taste_categories

  before_validation :assign_taste_category
  before_create :make_admin_if_first_user

  validates_presence_of :first_name

  scope :admins,      -> { where(:role => 'Admin') }
  scope :nonadmins,   -> { where('users.role != ?', 'Admin')  }

  def admin?; self.role == 'Admin'; end

  def name; self.first_name; end

  def has_google_auth?
    google_access_token.present? && google_auth_expires_at.present?; end
  def google_auth_expired?; google_auth_expires_at <= Time.now; end
  def google_auth_active?; has_google_auth? && !google_auth_expired?; end
  def clear_google_tokens!; clear_google_tokens && save; end
  def clear_google_tokens
    return unless has_google_auth?
    self.google_access_token = nil
    self.google_auth_expires_at = nil
    true
  end
  def self.build_google_auth_obj
    auth               = Google::APIClient.new.authorization
    auth.client_id     = Rails.application.secrets.google_client_id
    auth.client_secret = Rails.application.secrets.google_client_secret
    auth.redirect_uri  = Rails.application.secrets.google_callback_uri || 
                         DEFAULT_OAUTH_CALLBACK_URI
    auth.scope = [
      "https://www.googleapis.com/auth/drive",
      "https://spreadsheets.google.com/feeds/" # ,
      # "email", "profile"
    ]
    # auth.additional_parameters = {'access_type' => 'offline'}
    auth
  end
  def do_google_auth_with_code!(code, auth=nil)
    auth ||= User.build_google_auth_obj
    auth.code = code
    auth.fetch_access_token!
    return false unless auth.access_token.present?
    self.google_access_token  = auth.access_token
    self.google_auth_expires_at = auth.expires_at
    save!
  end
  def google_drive_session
    if self.google_drive_session_cache.present?
      return self.google_drive_session_cache; end
    obtain_google_drive_session!
  end
  def obtain_google_drive_session!
    raise GoogleAuthRequiredError.new unless google_auth_active?
    begin
      session = GoogleDrive.login_with_oauth google_access_token
      self.google_drive_session_cache = session
    rescue Google::APIClient::AuthorizationError
      clear_google_tokens!
      raise GoogleAuthRequiredError.new
    end
  end
  def obtain_google_drive_session_in_console!
    begin
      obtain_google_drive_session!
    rescue GoogleAuthRequiredError
      auth = build_google_auth_obj
      print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
      print("2. Enter the authorization code shown in the page: ")
      code = $stdin.gets.chomp
      do_google_auth_with_code! code, auth
      obtain_google_drive_session!
    end
  end
  def google_spreadsheets
    begin
      google_drive_session.files.select{|f| f.is_a? GoogleDrive::Spreadsheet }
    rescue Google::APIClient::AuthorizationError, Google::APIClient::ClientError
      clear_google_tokens!
      obtain_google_drive_session!
      google_spreadsheets
    end
  end

  class GoogleAuthRequiredError < StandardError
    # attr_reader :auth_uri
    # def initialize(auth_uri); @auth_uri = auth_uri; end
    def message; "Google authorization is required."; end
  end

  private
  def make_admin_if_first_user
    self.role = 'Admin' unless Rails.env.test? || User.any?
  end
  def assign_taste_category
    if self.taste_category_name.present?
      tc_attrs = { name: self.taste_category_name }
      matching_category = TasteCategory.find_by tc_attrs
      self.taste_categories << if matching_category.present?
                                 matching_category
                               else
                                 TasteCategory.new(tc_attrs)
                               end
    end
  end

end
