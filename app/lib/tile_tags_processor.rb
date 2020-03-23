class TileTagsProcessor

    def initialize(extracted_user)
        @extracted_user = extracted_user
    end
    
    def process_tile_taggings(tile_tags_ids_array, current_tile, action_type)
        validated_tile_tags_ids_array = []
    
        tile_tags_ids_array.each do |tile_tag_id|
            tile_tag = @extracted_user.tags.find_by(id: tile_tag_id)

            if tile_tag != nil
                validated_tile_tags_ids_array << tile_tag.id
            end
        end

        clean_tile_taggings(current_tile) if action_type == :update

        validated_tile_tags_ids_array.each do |tile_tag_id|
            tagging_data = {
                tag_id: tile_tag_id
            }
            
            current_tile.taggings.create!(tagging_data)
        end

        {status: :ok}
    end

    private

        def clean_tile_taggings(current_tile)
            current_tile.taggings.each do |tagging|
                tagging.destroy
            end
        end

end