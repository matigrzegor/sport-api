class CreateTileDiets < ActiveRecord::Migration[5.2]
  def change
    create_table :tile_diets do |t|
      t.string :tile_diet_meal, null: false
      t.string :tile_diet_energy_unit
      t.integer :tile_diet_energy_amount
      t.string :tile_diet_carbohydrates_unit
      t.integer :tile_diet_carbohydrates_amount
      t.string :tile_diet_protein_unit
      t.integer :tile_diet_protein_amount
      t.string :tile_diet_fat_unit
      t.string :string
      t.integer :tile_diet_fat_amount
      t.text :tile_diet_note
      t.references :tile, index: true, foreign_key: true

      t.timestamps
    end
  end
end
