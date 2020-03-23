module Api::V1

    class PlatformNotesController < ApplicationController
        include Secured
        include AthleteRoled
        include Api::V1::PlatformNoteSerializer
        before_action :current_athlete_platform, only: [:create, :destroy, :update]
        before_action :current_platform_note, only: [:destroy, :update]

        def create
            platform_note = @current_athlete_platform.platform_notes.create!(platform_note_params)

            render json: serialize_platform_note(platform_note), status: :ok
        end

        def update
            @current_platform_note.update!(platform_note_params)

            render json: serialize_platform_note(@current_platform_note), status: :ok
        end

        def destroy
            @current_platform_note.destroy

            render json: {message: "Platform note was successfully deleted"}, status: :ok
        end

        private

            def platform_note_params
                params.permit(:platform_note_name, :platform_note_link, :platform_note_description)
            end

            def current_athlete_platform
                @current_athlete_platform = @extracted_user.athlete_platforms.find(params[:athlete_platform_id])
            end

            def current_platform_note
                @current_platform_note = @current_athlete_platform.platform_notes.find(params[:id])
            end
            
    end

end

# Controller for role: athlete.