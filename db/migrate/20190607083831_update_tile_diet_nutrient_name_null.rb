class UpdateTileDietNutrientNameNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tile_diet_nutrients, :tile_diet_nutrient_name, false
  end
end
