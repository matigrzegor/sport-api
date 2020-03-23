module Api::V1

    class ToAppInvitationsController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::ToAppInvitationSerializer
        before_action :error_creator, only: [:create, :destroy]
        before_action :check_access_to_make_platform_invites, only: :create
        before_action :current_athlete_platform, only: :create
        before_action :management_token, only: [:create, :destroy]
        before_action :check_whether_account_already_exist, only: :create
        before_action :current_pending_user_invitation, only: :destroy

        def create
            if @user_exist == false
                output = get_trainer_from_auth
                
                if output.first == 'ok'
                    @trainer_email = output.second['email']
                    @trainer_nick = output.second['nickname']
                    @athlete_email = to_app_invitation_params[:athlete_email]

                    pending_user_invitation = @current_athlete_platform.pending_user_invitations
                                                .create!(athlete_identifier: @athlete_email)

                    EmailProcessor.new(@athlete_email).to_app_invitation_email(@trainer_email, @trainer_nick)    
                
                    render json: serialize_pending_user_invitation(pending_user_invitation), status: :ok
                else
                    render json: @error_creator.create_error(500, 4), status: 500
                end
            else
                render json: @error_creator.create_error(404, 5), status: 400
            end
        end

        def destroy
            @current_pending_user_invitation.destroy

            render json: {message: 'To-app-invitation was successfully deleted'}, status: 200
        end


        private

            def to_app_invitation_params
                permited = params.permit(:athlete_email)
                {athlete_email: String(permited[:athlete_email])}
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

            def current_pending_user_invitation
                @current_pending_user_invitation = @extracted_user.athlete_platforms.find(params[:athlete_platform_id])
                                                    .pending_user_invitations.find(params[:id])
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
                @error_creator = Errorer::ErrorCreator.new(:pending_user_invitations)
            end

            def get_trainer_from_auth
                AuthZeroHelper.new(@management_token).get_user_from_auth(@extracted_user.auth_sub)
            end

            def check_whether_account_already_exist
                output = AuthZeroHelper.new(@management_token)
                        .check_whether_account_already_exist(to_app_invitation_params[:athlete_email])

                if output[:status] == :ok
                    @user_exist = output[:user_exist]
                else
                    render json: @error_creator.create_error(500, 7), status: 500
                end
            end

            def check_access_to_make_platform_invites
                if @account_checker.permitted_to_make_platform_invite? == false
                    render json: @error_creator.create_error(403, 6), status: 403
                end
            end
    end

end

# Controller for role: trainer.