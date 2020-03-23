module Api::V1

    class AthletedInvitationsController < ApplicationController
        include Secured
        include AthleteRoled
        include Api::V1::InvitationSerializer
        before_action :error_creator, only: [:destroy, :index]
        before_action :current_invitation, only: :destroy
        before_action :management_token, only: [:destroy, :index]
        
        def index
            invitations = Invitation.where(recipient_id: @extracted_user.auth_sub)

            invitations_data = return_invitations_data(invitations)

            render json: serialize_full_invitations(invitations_data), status: 200
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
                    render json: @error_creator.create_error(500, 4), status: 500
                end
            else
                render json: @error_creator.create_error(500, 3), status: 500
            end 
        end

        private

            def current_invitation
                current_invitation = Invitation.find_by(platform_token: String(params[:platform_token]))

                if current_invitation != nil
                    if current_invitation.recipient_id == @extracted_user.auth_sub
                        @current_invitation = current_invitation
                    else
                        render json: @error_creator.create_error(404, 1), status: 404
                    end
                else
                    render json: @error_creator.create_error(404, 2), status: 404
                end
            end

            def management_token
                management_array = ManagementToken.new.get_token
                if management_array.first == 'token'
                    @management_token = management_array.second
                elsif management_array.first == 'error'
                    render json: @error_creator.create_specific_error(:auth0_management_token_error), status: 500
                end
            end

            def error_creator
                @error_creator = Errorer::ErrorCreator.new(:athleted_invitations)
            end

            def return_invitations_data(invitations)
                invitations_data = []
                
                if invitations != nil
                    invitations.each do |invitation|
                        athlete_platform = invitation.athlete_platform
                        
                        if athlete_platform != nil
                            memberships = athlete_platform.memberships.where(membership_status: 'founder')

                            if memberships.count == 1
                                trainer = memberships.first.user
                                if trainer != nil
                                    auth_sub = trainer.auth_sub

                                    output = AuthZeroHelper.new(@management_token).get_user_from_auth(auth_sub)
                
                                    if output.first == 'ok'
                                        invitations_data << {invitation: invitation, trainer_auth_body: output.second}
                                    end
                                end
                            end
                        end
                    end
                end

                invitations_data
            end
    end

end

# Controller for role: athlete.
# -----------------------------------------------------------------------------
# With this controller athlete can reject invitaitons from trainers.