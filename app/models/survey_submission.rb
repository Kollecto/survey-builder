class SurveySubmission < ActiveRecord::Base
  include SurveyPageNavigation

  serialize :submission

  belongs_to :user
  belongs_to :survey_iteration
  has_many :survey_pages, :through => :survey_iteration
  belongs_to :current_page, :class_name => 'SurveyPage'

  before_validation :set_started_at
  before_validation :attach_survey_iteration

  validates_presence_of :user, :survey_iteration, :started_at

  scope :completed, -> { where('survey_submissions.completed_at IS NOT NULL') }
  scope :not_completed, -> { where('survey_submissions.completed_at IS NULL') }

  def completed?; completed_at.present?; end

  def update_submission!(new_data)
    self.submission = (submission||{}).dup.deep_merge new_data
    if new_data.keys.last == "question_#{current_page.survey_questions.last.id}"
      self.current_page_id = next_page_id
    end
    save
  end

  def answer_for(q); (submission||{})["question_#{q.id}"]; end

  private
  def set_started_at; self.started_at ||= Time.now; end
  def attach_survey_iteration
    self.survey_iteration ||= SurveyIteration.last || SurveyIteration.create!
    self.current_page ||= survey_iteration.survey_pages.first
  end

end
