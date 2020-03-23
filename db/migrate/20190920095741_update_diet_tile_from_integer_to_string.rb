class UpdateDietTileFromIntegerToString < ActiveRecord::Migration[5.2]
  def change
    change_column :tile_diets, :tile_diet_energy_amount, :string
    change_column :tile_diets, :tile_diet_carbohydrates_amount, :string
    change_column :tile_diets, :tile_diet_protein_amount, :string
    change_column :tile_diets, :tile_diet_fat_amount, :string
    change_column :tile_diet_nutrients, :tile_diet_nutrient_amount, :string
  end
end
