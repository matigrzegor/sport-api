module Api::V1

    class TrainingPlanBoardNotesController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::BoardNoteSerializer
        before_action :current_training_plan, only: [:index, :create, :destroy, :update]
        before_action :current_board_note, only: [:destroy, :update]

        def index
            board_notes = @current_training_plan.board_notes

            render json: serialize_board_notes(board_notes), status: :ok
        end
        
        def create
            board_note = @current_training_plan.board_notes.create!(board_note_params)
            
            render json: serialize_board_note(board_note), status: :ok
        end

        def destroy
            @current_board_note.destroy
            
            render json: {message: "Note was successfully deleted"}, status: :ok
        end

        def update
            @current_board_note.update!(board_note_params)

            render json: serialize_board_note(@current_board_note), status: :ok
        end

        private   
            
            def board_note_params
                params.permit(:board_note_name, :board_note_link, :board_note_description)
            end

            def current_training_plan
                @current_training_plan = @extracted_user.training_plans.find(params[:training_plan_id])
            end

            def current_board_note
                @current_board_note = @current_training_plan.board_notes.find(params[:id])
            end
    end

end

# Controller for role: trainer.