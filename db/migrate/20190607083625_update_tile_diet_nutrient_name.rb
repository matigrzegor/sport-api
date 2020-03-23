class UpdateTileDietNutrientName < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tile_diet_nutrients, :tile_diet_nutrient_name, nil
  end
end
