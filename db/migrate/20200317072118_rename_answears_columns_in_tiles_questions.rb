class RenameAnswearsColumnsInTilesQuestions < ActiveRecord::Migration[5.2]
  def change
    rename_column :tile_questions, :tile_answear_numeric, :tile_answer_numeric
    rename_column :tile_questions, :tile_answear_numeric_from, :tile_answer_numeric_from
    rename_column :tile_questions, :tile_answear_numeric_to, :tile_answer_numeric_to
    rename_column :tile_questions, :tile_answears_descriptives, :tile_answers_descriptives
  end
end
