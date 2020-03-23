module Marketplace

    class TileGood < Good
        include Api::V1::DietTileSerializer
        include Api::V1::QuestionTileSerializer
        include Api::V1::MotivationTileSerializer
        include Api::V1::TrainingTileSerializer

        attr_reader :data_hash

        def initialize(input_hash)
            good_content = generate_good_content(input_hash[:tile_id])
            
            @data_hash = {
                good_database_model: 'tile',
                good_creator: 'Gremmo',
                good_status: 'initial',
                good_content: good_content
            }
        end

        def self.create_good(input_hash)
            tile_good = self.new(input_hash)

            tile_good.data_hash
        end

        private

            def generate_good_content(tile_id)
                tile = Tile.find_by(id: tile_id)

                if tile != nil
                    tile_type = tile.tile_type
                    
                    @tile_hash = self.method(:"serialize_#{tile_type}_tile").call(tile)

                    processed_tile = @tile_hash.except(:id, :tile_tags)

                    if tile_type == 'question' || tile_type == 'motivation'
                        tile_association = @tile_hash[:"tile_#{tile_type}"].except(:id)
                        
                        processed_tile.delete(:"tile_#{tile_type}")
                        processed_tile.merge!({:"tile_#{tile_type}_attributes" => tile_association})
                    end
                    
                    if tile_type == 'diet'
                        tile_diets = @tile_hash[:tile_diets].map do |tile_diet|
                            tile_diet = tile_diet.except(:id)
                            
                            tile_diet_nutrients = tile_diet[:tile_diet_nutrients].map do |tile_diet_nutrient|
                                tile_diet_nutrient.except(:id)
                            end

                            processed_tile.delete(:tile_diet_nutrients)
                            tile_diet.merge({tile_diet_nutrients_attributes: tile_diet_nutrients})
                        end

                        processed_tile.delete(:tile_diets)
                        processed_tile.merge!({tile_diets_attributes: tile_diets})
                    end

                    if  tile_type == 'training'
                        tile_activities = @tile_hash[:tile_activities].map do |tile_activity|
                            tile_activity.except(:id)
                        end
                        
                        processed_tile.delete(:tile_activities)
                        processed_tile.merge!({tile_activities_attributes: tile_activities})
                    end

                    @processed_tile = processed_tile
                end

                

                JSON.generate(@processed_tile)
            end
    
    end

end