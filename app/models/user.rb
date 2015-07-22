class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :taste_category_name

  has_many :survey_submissions
  has_and_belongs_to_many :taste_categories

  before_validation :assign_taste_category
  before_create :make_admin_if_first_user

  validates_presence_of :first_name

  scope :admins,      -> { where(:role => 'Admin') }
  scope :nonadmins,   -> { where('users.role != ?', 'Admin')  }

  def admin?; self.role == 'Admin'; end

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
