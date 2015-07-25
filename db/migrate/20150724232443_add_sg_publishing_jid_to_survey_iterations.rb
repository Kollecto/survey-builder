class AddSgPublishingJidToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :sg_publishing_jid, :string
    add_column :survey_iterations, :publish_to_sg_cancelled_at, :datetime
  end
end
