class TileActivity < ApplicationRecord
    belongs_to :tile

    # length validations
    validates :tile_activity_name, :tile_activity_unit, :tile_activity_intensity, :tile_activity_rest_unit,
                :tile_activity_amount, :tile_activity_intensity_amount, :tile_activity_rest_amount,
                :tile_activity_rest_intensity_amount, :tile_activity_rest_after_activity_unit,
                :tile_activity_rest_after_activity_amount, :tile_activity_rest_after_activity_intensity,
                :tile_activity_rest_after_activity_intensity_amount, length: {maximum: 255}
    validates :tile_activity_note, length: {maximum: 30000}
end
