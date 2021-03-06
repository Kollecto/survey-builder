class SurveyPage < ActiveRecord::Base
  include SurveyPageNavigation

  serialize :metadata
  belongs_to :survey_iteration
  has_many :survey_questions, :dependent => :destroy

  after_initialize :fetch_title_and_desc_from_metadata
  after_initialize :initialize_questions

  scope :imported_from_google, -> {
    where('survey_pages.imported_from_google_at IS NOT NULL') }
  scope :not_imported_from_google, -> {
    where('survey_pages.imported_from_google_at IS NULL') }
  scope :published_to_sg, -> { where('survey_pages.sg_page_id IS NOT NULL') }
  scope :not_published_to_sg, -> { where('survey_pages.sg_page_id IS NULL') }

  def fetch_title_and_desc_from_metadata
    return unless self.metadata.present?
    self.title ||= self.metadata['name-by-artist']
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
      :survey_options_attributes => art_attributes.map{|aa| {
        :title => aa.capitalize, :reporting_value => aa.capitalize } }
    # self.survey_questions.build :survey_iteration => self.survey_iteration,
    #                             :title => 'DISLIKED because...',
    #                             :previous_question => q2,
    #                             :parent_question => q1,
    #                             :parent_question_dependency => 'No'
  end

  def art_attributes
    self.survey_iteration.art_attribute_columns.select{|heading|
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
    return false if survey_iteration.publish_to_sg_cancelled?
    puts "Exporting survey page!"
    page = SurveyGizmo::API::Page.create sg_page_params
    if self.new_record? then self.sg_page_id = page.id
    else self.update_column(:sg_page_id, page.id) end
    self.survey_questions.reverse.each(&:export_to_survey_gizmo!)
  end
  def delete_from_survey_gizmo!
    return false unless self.sg_page.present?
    puts "Deleting page from Survey Gizmo!"
    self.survey_questions.published_to_sg.each(&:delete_from_survey_gizmo!)
    self.sg_page.destroy
    return true if new_record?
    self.sg_page_id = nil
    self.save
  end

end
