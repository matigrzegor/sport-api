module Api::V1

    module TrainingTileSerializer
        include Api::V1::TileTagSerializer

        def serialize_training_tile(training_tile)
            tile_tags = training_tile.tags.all
            {
                id: training_tile.id,
                tile_type: training_tile.tile_type,
                tile_type_name: training_tile.tile_type_name,
                tile_type_color: training_tile.tile_type_color,
                tile_title: training_tile.tile_title,
                tile_description: training_tile.tile_description,
                tile_activities_sets: training_tile.tile_activities_sets,
                tile_activities_sets_rest_unit: training_tile.tile_activities_sets_rest_unit,
                tile_activities_sets_rest_amount: training_tile.tile_activities_sets_rest_amount,
                tile_activities_sets_rest_intensity_unit: training_tile.tile_activities_sets_rest_intensity_unit,
                tile_activities_sets_rest_intensity_amount: training_tile.tile_activities_sets_rest_intensity_amount,
                tile_activities: serialize_tile_activities(training_tile),
                tile_tags: serialize_tile_tags(tile_tags)
            }
        end
        
        def serialize_training_tiles(training_tiles)
            training_tiles.map do |training_tile|
                serialize_training_tile(training_tile)
            end
        end

        private

            def serialize_tile_activities(training_tile)
                training_tile.tile_activities.map do |tile_activity|
                    {
                        id: tile_activity.id,
                        tile_activity_name: tile_activity.tile_activity_name,
                        tile_activity_reps: tile_activity.tile_activity_reps,
                        tile_activity_unit: tile_activity.tile_activity_unit,
                        tile_activity_amount: tile_activity.tile_activity_amount,
                        tile_activity_intensity: tile_activity.tile_activity_intensity,
                        tile_activity_intensity_amount: tile_activity.tile_activity_intensity_amount,
                        tile_activity_rest_unit: tile_activity.tile_activity_rest_unit,
                        tile_activity_rest_amount: tile_activity.tile_activity_rest_amount,
                        tile_activity_rest_intensity: tile_activity.tile_activity_rest_intensity,
                        tile_activity_rest_intensity_amount: tile_activity.tile_activity_rest_intensity_amount,
                        tile_activity_note: tile_activity.tile_activity_note,
                        tile_activity_rest_after_activity_unit: tile_activity.tile_activity_rest_after_activity_unit,
                        tile_activity_rest_after_activity_amount: tile_activity.tile_activity_rest_after_activity_amount,
                        tile_activity_rest_after_activity_intensity: tile_activity.tile_activity_rest_after_activity_intensity,
                        tile_activity_rest_after_activity_intensity_amount: tile_activity.tile_activity_rest_after_activity_intensity_amount
                    }
                end
            end

    end

end