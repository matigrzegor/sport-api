class TileDietNutrient < ApplicationRecord
    belongs_to :tile_diet
   
    # length validations
    validates :tile_diet_nutrient_name, :tile_diet_nutrient_unit, :tile_diet_nutrient_amount, length: {maximum: 255}
end
