module Api::V1

    module TileTagSerializer
        
        def serialize_tile_tag(tile_tag)
            {
                id: tile_tag.id,
                tag_name: tile_tag.tag_name,
                user_id: tile_tag.user_id
            }
        end
        

        def serialize_tile_tags(tile_tags)
            tile_tags.map do |tile_tag|
                serialize_tile_tag(tile_tag)
            end
        end

    end

end