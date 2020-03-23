module Api::V1

    class AttendantMembershipsController < ApplicationController
        include Secured
        include AthleteRoled
        before_action :error_creator, only: [:create, :destroy, :show]
        before_action :current_athlete_platform_form_invitatian, only: :create
        before_action :current_membership, only: [:destroy, :show]
        before_action :management_token, only: :create

        def show
            render json: {is_in_active_platform: true}, status: 200
        end

        def create
            invitation_process = InvitationProcess.new(@management_token, @invitation.recipient_id)

            if invitation_process.prepared_to_process == true
                output = invitation_process.destroy_invitation(@invitation)
        
                if output.first == 'ok'
                    invitation = output.second
                    invitation.destroy
                    
                    membership = @current_athlete_platform.memberships.create!(user_id: @extracted_user.id,
                                                                    membership_status: "attendant")

                    trainer_auth_sub = @current_athlete_platform.memberships.where(membership_status: "founder")[0].user.auth_sub

                    PlatformChat.create!({
                        athlete_platform_id: @current_athlete_platform.id,
                        trainer_auth_sub: trainer_auth_sub,
                        athlete_auth_sub: @extracted_user.auth_sub
                    })

                    render json: {message: 'You have successfully joined the group'}, status: :ok
                else
                    render json: @error_creator.create_error(500, 7), status: 500
                end
            else
                render json: @error_creator.create_error(500, 6), status: 500
            end

        rescue ActiveRecord::RecordInvalid
            render json: @error_creator.create_error(404, 3), status: 404
        end

        def destroy
            current_athlete_platform = @current_membership.athlete_platform

            current_athlete_platform.plan_appends.first.destroy
            
            PlatformChat.find_by(athlete_platform_id: current_athlete_platform.id).destroy

            @current_membership.destroy

            render json: {message: 'You have successfully abandoned the group'}, status: :ok
        end

        private

            def attendant_membership_params
                params.dig(:platform_token)
            end
            
            def current_athlete_platform_form_invitatian
                @invitation = Invitation.find_by(platform_token: attendant_membership_params)
                
                if @invitation != nil
                    if @invitation.recipient_id == @extracted_user.auth_sub
                        @current_athlete_platform = @invitation.athlete_platform  
                    else
                        render json: @error_creator.create_error(404, 3), status: 404
                    end
                else
                    render json: @error_creator.create_error(404, 2), status: 404
                end
            end

            def current_membership
                memberships = @extracted_user.memberships.where(membership_status: 'attendant')
                if memberships.count == 1
                    @current_membership = memberships.first
                elsif memberships.count == 0
                    render json: {is_in_active_platform: false}, status: 200
                end
            end

            def error_creator
                @error_creator = Errorer::ErrorCreator.new(:attendant_memberships)
            end

            def management_token
                management_array = ManagementToken.new.get_token
                if management_array.first == 'token'
                    @management_token = management_array.second
                elsif management_array.first == 'error'
                    render json: @error_creator.create_specific_error(:auth0_management_token_error), status: 500
                end
			end
    end

end

# Controller for role: athlete.
# -------------------------------------------------------------
# We use this controller to create memberships (model: membership) with attendant status which means creating
# athlete memberships. 
# It means that with this controller athletes can join athlete platforms (model: athlete_platform)and leave 
# those platforms.
