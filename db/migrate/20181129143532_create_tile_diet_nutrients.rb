class CreateTileDietNutrients < ActiveRecord::Migration[5.2]
  def change
    create_table :tile_diet_nutrients do |t|
      t.string :tile_diet_nutrient_name
      t.string :tile_diet_nutrient_unit
      t.integer :tile_diet_nutrient_amount
      t.references :tile_diet, index: true, foreign_key: true

      t.timestamps
    end
  end
end
