class TileDiet < ApplicationRecord
    belongs_to :tile
    has_many :tile_diet_nutrients, dependent: :destroy

    accepts_nested_attributes_for :tile_diet_nutrients, allow_destroy: true

    # length validations
    validates :tile_diet_meal, :tile_diet_energy_unit, :tile_diet_carbohydrates_unit,
                :tile_diet_protein_unit, :tile_diet_fat_unit, :tile_diet_energy_amount,
                :tile_diet_carbohydrates_amount, :tile_diet_protein_amount, 
                :tile_diet_fat_amount, length: {maximum: 255}
    validates :tile_diet_note, length: {maximum: 30000}
end
