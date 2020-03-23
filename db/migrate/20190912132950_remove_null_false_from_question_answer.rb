class RemoveNullFalseFromQuestionAnswer < ActiveRecord::Migration[5.2]
  def change
    change_column_null :question_answers, :question_answer, true
  end
end
