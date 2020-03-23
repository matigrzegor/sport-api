module Api::V1

    class UserBoardNotesController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::BoardNoteSerializer
        before_action :current_board_note, only: [:destroy, :update]

        def index
            board_notes = @extracted_user.board_notes

            render json: serialize_board_notes(board_notes), status: :ok
        end

        def create
            board_note = @extracted_user.board_notes.create!(board_note_params)
            
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

            def current_board_note
                @current_board_note = @extracted_user.board_notes.find(params[:id])
            end
    end

end

# Controller for role: trainer.