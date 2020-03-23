module Api::V1

    class InitialTileCollectionsController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::TilesSerializer 
        
        def create
            initial_tile_goods = MarketplaceGood.where(good_status: 'initial')

            tiles = []

            initial_tile_goods.each do |initial_tile_good|
                if initial_tile_good.good_database_model == 'tile'
                    good_content = initial_tile_good.good_content

                    data_hash = JSON.parse(good_content)

                    tile = @extracted_user.tiles.create!(data_hash)

                    tiles << tile
                end
            end

            render json: serialize_tiles(tiles), status: :ok
        end
            
    end

end

# Controller for role: trainer.