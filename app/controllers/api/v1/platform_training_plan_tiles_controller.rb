module Api::V1
    
    class PlatformTrainingPlanTilesController < ApplicationController
        include Secured
        include AthleteRoled
        include Athleted
        include Api::V1::TilesSerializer

        def index
            tiles = @plan_append.training_plan.tiles.all.uniq

            render json: serialize_tiles(tiles), status: :ok
        end

    end

end

# Controller for role: athlete.