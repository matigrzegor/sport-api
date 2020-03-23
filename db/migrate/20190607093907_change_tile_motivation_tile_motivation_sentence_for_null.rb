class ChangeTileMotivationTileMotivationSentenceForNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tile_motivations, :tile_motivation_sentence, false
  end
end
