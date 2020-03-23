class ChangeTileQuestionTileAskQuestionForNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tile_questions, :tile_ask_question, false
  end
end
