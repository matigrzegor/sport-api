class TileMotivation < ApplicationRecord
	belongs_to :tile

	# length validations
	validates :tile_motivation_sentence, :tile_motivation_link, length: {maximum: 255}
end
