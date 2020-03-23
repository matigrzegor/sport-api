module Api::V1

    class AthleteStatusesController < ApplicationController
        include Secured
        include TrainerRoled
        before_action :current_athlete_platform, only: :show
        
        def show
            attendant_memberships = @current_athlete_platform.memberships.where(membership_status: 'attendant')

            if attendant_memberships.count == 1
                attendant_membership = attendant_memberships.first
                
                if attendant_membership != nil
                    data_hash = {
                        athlete_in_platform: true,
                        attendant_membership_id: attendant_membership.id
                    }
                    
                    render json: data_hash, status: 200
                end
                
            elsif attendant_memberships.count == 0
                data_hash = {
                    athlete_in_platform: false
                }
                
                render json: data_hash, status: 200
            end
        end

        private

            def current_athlete_platform
                current_athlete_platform = @extracted_user.athlete_platforms.find(params[:athlete_platform_id])

                membership = current_athlete_platform.memberships.where(user_id: @extracted_user.id).first
                if membership != nil
                    if membership.membership_status == "founder"
                        @current_athlete_platform = current_athlete_platform
                    else
                        raise ActiveRecord::RecordNotFound
                    end
                end
            end

    end

end

# Controller for role: trainer.