module Api::V1

    module DietTileSerializer
        include Api::V1::TileTagSerializer

        def serialize_diet_tile(diet_tile)
            tile_tags = diet_tile.tags.all
            {
                id: diet_tile.id,
                tile_type: diet_tile.tile_type,
                tile_type_name: diet_tile.tile_type_name,
                tile_type_color: diet_tile.tile_type_color,
                tile_title: diet_tile.tile_title,
                tile_description: diet_tile.tile_description,
                tile_activities_sets: diet_tile.tile_activities_sets,
                tile_activities_sets_rest_unit: diet_tile.tile_activities_sets_rest_unit,
                tile_activities_sets_rest_amount: diet_tile.tile_activities_sets_rest_amount,
                tile_activities_sets_rest_intensity_unit: diet_tile.tile_activities_sets_rest_intensity_unit,
                tile_activities_sets_rest_intensity_amount: diet_tile.tile_activities_sets_rest_intensity_amount,
                tile_diets: serialize_tile_diets(diet_tile),
                tile_tags: serialize_tile_tags(tile_tags)
            }
        end
        
        def serialize_diet_tiles(diet_tiles)
            diet_tiles.map do |diet_tile|
                serialize_diet_tile(diet_tile)
            end
        end

        private

            def serialize_tile_diets(diet_tile)
                diet_tile.tile_diets.map do |tile_diet|
                    {
                        id: tile_diet.id,
                        tile_diet_meal: tile_diet.tile_diet_meal,
                        tile_diet_energy_unit: tile_diet.tile_diet_energy_unit,
                        tile_diet_energy_amount: tile_diet.tile_diet_energy_amount,
                        tile_diet_carbohydrates_unit: tile_diet.tile_diet_carbohydrates_unit,
                        tile_diet_carbohydrates_amount: tile_diet.tile_diet_carbohydrates_amount,
                        tile_diet_protein_unit: tile_diet.tile_diet_protein_unit,
                        tile_diet_protein_amount: tile_diet.tile_diet_protein_amount,
                        tile_diet_fat_unit: tile_diet.tile_diet_fat_unit,
                        tile_diet_fat_amount: tile_diet.tile_diet_fat_amount,
                        tile_diet_note: tile_diet.tile_diet_note,
                        tile_diet_nutrients: serialize_tile_diet_nutrients(tile_diet)
                    }
                end.reverse
            end

            def serialize_tile_diet_nutrients(tile_diet)
                tile_diet.tile_diet_nutrients.map do |tile_diet_nutrient|
                    {
                        id: tile_diet_nutrient.id,
                        tile_diet_nutrient_name: tile_diet_nutrient.tile_diet_nutrient_name,
                        tile_diet_nutrient_unit: tile_diet_nutrient.tile_diet_nutrient_unit,
                        tile_diet_nutrient_amount: tile_diet_nutrient.tile_diet_nutrient_amount
                    }
                end
            end

    end

end