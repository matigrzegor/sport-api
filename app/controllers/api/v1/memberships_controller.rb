module Api::V1

    class MembershipsController < ApplicationController
        include Secured
        include TrainerRoled
        before_action :current_athlete_platform, only: :destroy

        def destroy
            membership = @current_athlete_platform.memberships.find(params[:id])
            
            if membership.membership_status == 'attendant'
                @current_athlete_platform.plan_appends.first.destroy

                membership.destroy

                PlatformChat.find_by(athlete_platform_id: @current_athlete_platform.id).destroy

                render json: {message: "Athlete was successfully removed form the platform"}, status: :ok
            else
                render json: Errorer::ErrorCreator.new(:memberships).create_error(400, 1), status: 400
            end          
        end

        private
            
            def current_athlete_platform
                @current_athlete_platform = @extracted_user.athlete_platforms.find(params[:athlete_platform_id])
            end
    end

end

# Controller for role: trainer.