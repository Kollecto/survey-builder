class SurveyPage < ActiveRecord::Base
  include SurveyPageNavigation

  serialize :metadata
  belongs_to :survey_iteration
  has_many :survey_questions

  after_initialize :fetch_title_and_desc_from_metadata
  after_initialize :initialize_questions

  def fetch_title_and_desc_from_metadata
    return unless self.metadata.present?
    self.title ||= self.metadata['title-by-artist']
    self.description ||= "<img alt='' src='#{self.metadata['image-url']}' /><br style='line-height:22.4000015258789px;' /><br style='line-height:22.4000015258789px;' /><span style='font-size:18px;'><span style='font-family:Calibri;'>#{self.metadata['medium-size-edition-price']}</span></span><br /><br style='line-height:22.4000015258789px;' /><strong style='line-height:22.3999996185303px;'><a href='http://buy.artkollecto.com'>buy.artkollecto.com</a></strong>"
    # self.description += "<script type='text/javascript'>alert('hi!');</script>" (:
  end
  
  def initialize_questions
    return if self.survey_questions.any?
    self.survey_questions.build :survey_iteration => self.survey_iteration,
      :title => 'Do you like this?',
      :survey_options_attributes => [ {
        :title => "<img src='http://surveygizmolibrary.s3.amazonaws.com/library/337398/rsz_1thumb_up.png' />",
        :reporting_value => 'Yes'
      }, {
        :title => "<img src='http://surveygizmolibrary.s3.amazonaws.com/library/337398/rsz_thumb_down.png' />",
        :reporting_value => 'No' } ]
    self.survey_questions.build :survey_iteration => self.survey_iteration,
      :title => 'LIKED or DISLIKED because...',
      # :previous_question => q1,
      # :parent_question => q1,
      # :parent_question_dependency => 'Yes',
      :question_type => 'checkbox',
      :survey_options_attributes => taste_options.map{|to| {
        :title => to.capitalize, :reporting_value => to.capitalize } }
    # self.survey_questions.build :survey_iteration => self.survey_iteration,
    #                             :title => 'DISLIKED because...',
    #                             :previous_question => q2,
    #                             :parent_question => q1,
    #                             :parent_question_dependency => 'No'
  end

  def taste_options
    self.survey_iteration.worksheet_header_row[14..-1].select{|heading|
      !heading.blank? && self.metadata[heading] == 'x' }
  end

  def sg_page
    return unless self.sg_page_id.present?
    SurveyGizmo::API::Page.first id: self.sg_page_id,
       survey_id: self.survey_iteration.sg_survey_id
  end
  def sg_page_params
    {
      :survey_id => self.survey_iteration.sg_survey_id,
      :title => self.title,
      :description => self.description
    }.dup.merge(metadata.present? ? metadata[:sg_params] || {} : {})
  end
  def export_to_survey_gizmo!
    puts "Exporting survey page!"
    page = SurveyGizmo::API::Page.create sg_page_params
    self.sg_page_id = page.id
    self.survey_questions.reverse.each(&:export_to_survey_gizmo!)
  end

end
