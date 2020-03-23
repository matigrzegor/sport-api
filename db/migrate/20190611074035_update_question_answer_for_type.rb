class UpdateQuestionAnswerForType < ActiveRecord::Migration[5.2]
  def change
    change_column :question_answers, :question_answer, :string
  end
end
