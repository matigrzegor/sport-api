module Api::V1

    module MotivationTileSerializer
        include Api::V1::TileTagSerializer

        def serialize_motivation_tile(motivation_tile)
            tile_tags = motivation_tile.tags.all
            {
                id: motivation_tile.id,
                tile_type: motivation_tile.tile_type,
                tile_type_name: motivation_tile.tile_type_name,
                tile_type_color: motivation_tile.tile_type_color,
                tile_title: motivation_tile.tile_title,
                tile_description: motivation_tile.tile_description,
                tile_activities_sets: motivation_tile.tile_activities_sets,
                tile_activities_sets_rest_unit: motivation_tile.tile_activities_sets_rest_unit,
                tile_activities_sets_rest_amount: motivation_tile.tile_activities_sets_rest_amount,
                tile_activities_sets_rest_intensity_unit: motivation_tile.tile_activities_sets_rest_intensity_unit,
                tile_activities_sets_rest_intensity_amount: motivation_tile.tile_activities_sets_rest_intensity_amount,
                tile_motivation: serialize_tile_motivation(motivation_tile),
                tile_tags: serialize_tile_tags(tile_tags)
            }
        end
        
        def serialize_motivation_tiles(motivation_tiles)
            motivation_tiles.map do |motivation_tile|
                serialize_motivation_tile(motivation_tile)
            end
        end

        private

            def serialize_tile_motivation(motivation_tile)
                tile_motivation = motivation_tile.tile_motivation
                if tile_motivation == nil
                    {}
                else
                    {
                        id: tile_motivation.id,
                        tile_motivation_sentence: tile_motivation.tile_motivation_sentence,
                        tile_motivation_link: tile_motivation.tile_motivation_link
                    }
                end
            end

    end

end