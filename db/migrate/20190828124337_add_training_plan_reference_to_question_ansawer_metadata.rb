class AddTrainingPlanReferenceToQuestionAnsawerMetadata < ActiveRecord::Migration[5.2]
  def change
    add_reference :question_answer_metadata, :training_plan, index: true
  end
end
