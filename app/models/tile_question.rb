class TileQuestion < ApplicationRecord
    belongs_to :tile

    # length validations
    validates :tile_ask_question, length: {maximum: 255}
    validates :tile_answers_descriptives, length: {maximum: 510}

end