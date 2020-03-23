module Api::V1

    class InvitationsController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::InvitationSerializer
        before_action :error_creator, only: [:create, :destroy]
        before_action :check_access_to_make_platform_invites, only: :create
        before_action :current_athlete_platform, only: :create
        before_action :current_invitation, only: :destroy
        before_action :management_token, only: [:create, :destroy]

        def create
            invitation_process = InvitationProcess.new(@management_token, invitation_params[:user_id])

            if invitation_process.prepared_to_process == true
                output = invitation_process.perform_invitation(@current_athlete_platform)
        
                if output.first == 'ok'
                    invitation = output.second
                    invitation.save!
                    render json: serialize_invitation(invitation), status: :ok
                elsif output.first == 'create-invitation-error'
                    render json: @error_creator.create_error(500, 8), status: 500
                elsif output.first == 'get-trainer-error'
                    render json: @error_creator.create_error(500, 7), status: 500
                end
            else
                render json: @error_creator.create_error(500, 6), status: 500
            end
        end

        def destroy
            invitation_process = InvitationProcess.new(@management_token, @current_invitation.recipient_id)

            if invitation_process.prepared_to_process == true
                output = invitation_process.destroy_invitation(@current_invitation)
        
                if output.first == 'ok'
                    invitation = output.second
                    invitation.destroy
                    render json: {message: 'Invitation was successfully deleted'}, status: :ok
                else
                    render json: @error_creator.create_error(500, 5), status: 500
                end
            else
                render json: @error_creator.create_error(500, 4), status: 500
            end 
        end

        private

            def invitation_params
                params.permit(:user_id)
            end

            def current_athlete_platform
                current_athlete_platform = @extracted_user.athlete_platforms.find(params[:athlete_platform_id])
                
                invitations_count = current_athlete_platform.invitations.count
                pending_user_invitations_count = current_athlete_platform.pending_user_invitations.count
                attendants_count = current_athlete_platform.memberships.where(membership_status: "attendant").count
                
                if invitations_count == 1
                    render json: @error_creator.create_error(400, 1), status: 400
                elsif attendants_count == 1
                    render json: @error_creator.create_error(400, 2), status: 400
                elsif pending_user_invitations_count == 1
                    render json: @error_creator.create_error(400, 3), status: 400
                elsif invitations_count == 0 && attendants_count == 0 && pending_user_invitations_count == 0
                    @current_athlete_platform = current_athlete_platform
                end
            end

            def error_creator
                @error_creator = Errorer::ErrorCreator.new(:invitations)
            end

            def current_invitation
                @current_invitation = @extracted_user.athlete_platforms.find(params[:athlete_platform_id])
                                                    .invitations.find(params[:id])
            end

            def management_token
                management_array = ManagementToken.new.get_token
                if management_array.first == 'token'
                    @management_token = management_array.second
                elsif management_array.first == 'error'
                    render json: @error_creator.create_specific_error(:auth0_management_token_error), status: 500
                end
            end

            def check_access_to_make_platform_invites
                if @account_checker.permitted_to_make_platform_invite? == false
                    render json: @error_creator.create_error(403, 4), status: 403
                end
            end
    end

end

# Controller for role: trainer.