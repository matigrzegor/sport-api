class UpdateQuestionAnswerMetadata < ActiveRecord::Migration[5.2]
  def change
    remove_column :question_answer_metadata, :training_plan_id, :bigint
    add_reference :question_answer_metadata, :calendar_assoc, index: true
  end
end
