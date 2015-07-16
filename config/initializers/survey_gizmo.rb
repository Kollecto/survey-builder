require 'survey-gizmo-ruby'

SurveyGizmo.setup user: Rails.application.secrets.survey_gizmo_user,
                  password: Rails.application.secrets.survey_gizmo_password
