class SurveyQuestion < ActiveRecord::Base

  serialize :metadata
  belongs_to :survey_page
  belongs_to :survey_iteration
  belongs_to :parent_question,   :class_name => 'SurveyQuestion'
  belongs_to :previous_question, :class_name => 'SurveyQuestion'
  has_many :survey_options

  accepts_nested_attributes_for :survey_options
  after_initialize :initialize_options

  def initialize_options
    self.survey_options.each do |opt|
      opt.survey_question = self
      opt.survey_page = self.survey_page
      opt.survey_iteration = self.survey_iteration
    end
  end

  def json_data; self.metadata.to_json; end

  def sg_question
    return unless self.sg_question_id.present?
    SurveyGizmo::API::Question.first id: self.sg_question_id,
               survey_id: self.survey_iteration.sg_survey_id,
               page_id:          self.survey_page.sg_page_id
  end
  def sg_question_params
    {
      :survey_id => self.survey_iteration.sg_survey_id,
      :page_id => self.survey_page.sg_page_id,
      :title => self.title,
      :type => self.question_type
    }.dup.merge(metadata.present? ? metadata[:sg_params] || {} : {})
  end
  def export_to_survey_gizmo!
    puts "Exporting survey question!"
    question = SurveyGizmo::API::Question.create sg_question_params
    if self.new_record? then self.sg_question_id = question.id
    else self.update_column(:sg_question_id, question.id) end
    if parent_question.present? || previous_question.present?
      if parent_question.present?
        # question.properties['piped_from'] = parent_question.sg_question_id
        # question.properties['dependent'] = parent_question.sg_question_id
        # question.properties['show_rules'] ||= {}
        # question.properties['show_rules']['id'] = rand(100000..999999).to_s
        # question.properties['show_rules']['atom'] ||= {}
        # question.properties['show_rules']['atom'].merge! 'type' => 3,
        #                     'value' => parent_question.sg_question_id
        # question.properties['show_rules']['operator'] = 4
        # question.properties['show_rules']['atom2'] ||= {}
        # question.properties['show_rules']['atom2'].merge! 'type' => 3,
        #                     'value' => self.parent_question_dependency
        # TODO: id attr maybe?
      end
      if previous_question.present?
        question.after = previous_question.sg_question_id
      end
      question.save
    end
    self.survey_options.each(&:export_to_survey_gizmo!)
  end

  def simpleform_input_type
    case question_type
    when 'radio' then :radio_buttons
    when 'checkbox' then :check_boxes
    else :string
    end
  end

end
