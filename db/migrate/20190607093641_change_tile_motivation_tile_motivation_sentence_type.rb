class ChangeTileMotivationTileMotivationSentenceType < ActiveRecord::Migration[5.2]
  def change
    change_column :tile_motivations, :tile_motivation_sentence, :string
  end
end
