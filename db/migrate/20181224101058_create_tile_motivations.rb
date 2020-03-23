class CreateTileMotivations < ActiveRecord::Migration[5.2]
  def change
    create_table :tile_motivations do |t|
      t.text :tile_motivation_sentence
      t.string :tile_motivation_link
      t.references :tile, index: true, foreign_key: true

      t.timestamps
    end
  end
end
