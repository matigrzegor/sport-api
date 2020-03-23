module Api::V1
    
    class PlatformTrainingPlanBoardNotesController < ApplicationController
        include Secured
        include AthleteRoled
        include Athleted
        include Api::V1::BoardNoteSerializer

        def show
            board_notes = @plan_append.training_plan.board_notes

            render json: serialize_board_notes(board_notes), status: :ok
        end

    end

end

# Controller for role: athlete.
