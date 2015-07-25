module Admin::SurveyIterationsHelper

  def survey_iteration_status_label(si, html_opts={})
    classes_to_add = "label label-#{status_class_for_survey_iteration(si)}"
    if html_opts.key?(:class)
      html_opts[:class] += " #{classes_to_add}"
    else
      html_opts[:class] = classes_to_add
    end
    preposition = si.status.include?('Delet') ? 'from' : 'to'
    content_tag(:span, html_opts) { "#{si.status} #{preposition} Survey Gizmo" }
  end

  def status_class_for_survey_iteration(si)
    case si.status
    when 'Published' then 'success'
    when 'Publishing' then 'info'
    when 'Cancelled Publishing', 'Deleting' then 'danger'
    else 'default'
    end
  end

end
