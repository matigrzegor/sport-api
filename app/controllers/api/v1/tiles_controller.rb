module Api::V1
    
    class TilesController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::TilesSerializer

        def index
            tiles = @extracted_user.tiles
                        
            render json: serialize_tiles(tiles), status: :ok
        end

    end
    
end

# Controller for role: trainer.
# -------------------------------------------------------------
# This controller is meant to get all user's tiles with associations form database. 
# In other words it gets all user's tile resources: DietTile, TrainingTile, MotivationTile and QuestionTile.