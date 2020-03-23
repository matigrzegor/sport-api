module Api::V1

    module QuestionTileSerializer
        include Api::V1::TileTagSerializer

        def serialize_question_tile(question_tile)
            tile_tags = question_tile.tags.all
            {
                id: question_tile.id,
                tile_type: question_tile.tile_type,
                tile_type_name: question_tile.tile_type_name,
                tile_type_color: question_tile.tile_type_color,
                tile_title: question_tile.tile_title,
                tile_description: question_tile.tile_description,
                tile_activities_sets: question_tile.tile_activities_sets,
                tile_activities_sets_rest_unit: question_tile.tile_activities_sets_rest_unit,
                tile_activities_sets_rest_amount: question_tile.tile_activities_sets_rest_amount,
                tile_activities_sets_rest_intensity_unit: question_tile.tile_activities_sets_rest_intensity_unit,
                tile_activities_sets_rest_intensity_amount: question_tile.tile_activities_sets_rest_intensity_amount,
                tile_question: serialize_tile_question(question_tile),
                tile_tags: serialize_tile_tags(tile_tags)
            }
        end
        
        def serialize_question_tiles(question_tiles)
            question_tiles.map do |question_tile|
                serialize_question_tile(question_tile)
            end
        end

        private

            def serialize_tile_question(question_tile)
                tile_question = question_tile.tile_question
                if tile_question == nil
                    {}
                else
                    {
                        id: tile_question.id,
                        tile_ask_question: tile_question.tile_ask_question,
                        tile_answer_numeric: tile_question.tile_answer_numeric,
                        tile_answer_numeric_from: tile_question.tile_answer_numeric_from,
                        tile_answer_numeric_to: tile_question.tile_answer_numeric_to,
                        tile_answers_descriptives: tile_question.tile_answers_descriptives
                    }
                end
            end

    end

end