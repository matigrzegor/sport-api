class UpdateQuestionAnswerForNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :question_answers, :question_date, false
    change_column_null :question_answers, :question_answer, false
  end
end
