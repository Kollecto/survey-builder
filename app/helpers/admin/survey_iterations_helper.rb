module Admin::SurveyIterationsHelper

  def survey_iteration_sg_status_label(si, html_opts={})
    classes_to_add = "label label-#{sg_status_class_for_survey_iteration(si)}"
    if html_opts.key?(:class) then html_opts[:class] += " #{classes_to_add}"
    else html_opts[:class] = classes_to_add end
    content_tag(:span, html_opts) {
      preposition = si.sg_status.include?('Delet') ? 'from' : 'to'
      (si.sg_status + "<span class='hidden-sm'>" +
       " #{preposition} Survey Gizmo</span>").html_safe }
  end

  def sg_status_class_for_survey_iteration(si)
    case si.sg_status
    when 'Published' then 'success'
    when 'Publishing' then 'info'
    when 'Cancelled Publishing', 'Deleting' then 'danger'
    else 'default'
    end
  end

  def survey_iteration_gd_status_label(si, html_opts={})
    classes_to_add = "label label-#{gd_status_class_for_survey_iteration(si)}"
    if html_opts.key?(:class) then html_opts[:class] += " #{classes_to_add}"
    else html_opts[:class] = classes_to_add end
    content_tag(:span, html_opts) {
      (si.gd_status + "<span class='hidden-sm'> from Google Drive</span>"
    ).html_safe }
  end

  def gd_status_class_for_survey_iteration(si)
    case si.gd_status
    when 'Imported' then 'success'
    when 'Importing' then 'info'
    when 'Failed to Import' then 'danger'
    else 'default'
    end
  end

end
