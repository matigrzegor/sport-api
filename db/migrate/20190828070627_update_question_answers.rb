class UpdateQuestionAnswers < ActiveRecord::Migration[5.2]
  def change
    remove_column :question_answers, :question_tile_id, :integer
    add_reference :question_answers, :tile, index: true
  end
end
