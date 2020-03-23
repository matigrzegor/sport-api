module Api::V1

    module TilesSerializer
        include Api::V1::DietTileSerializer
        include Api::V1::QuestionTileSerializer
        include Api::V1::MotivationTileSerializer
        include Api::V1::TrainingTileSerializer

        def serialize_tiles(tiles)
            tiles.map do |tile|
                if tile.tile_type == 'diet'
                    serialize_diet_tile(tile)
                elsif tile.tile_type == 'question'
                    serialize_question_tile(tile)
                elsif tile.tile_type == 'motivation'
                    serialize_motivation_tile(tile)
                elsif tile.tile_type == 'training'
                    serialize_training_tile(tile)
                end
            end
        end

    end

end