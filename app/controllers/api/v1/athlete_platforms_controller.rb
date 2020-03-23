module Api::V1
    
    class AthletePlatformsController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::AthletePlatformSerializer
        before_action :error_creator, only: [:index, :show, :create, :update, :destroy]
        before_action :check_access_to_make_athlete_platforms, only: :create
        before_action :current_athlete_platform, only: [:show, :destroy, :update]
        #before_action :management_token, only: :show
        before_action :return_athlete_status, only: :show

        def index
            athlete_platforms = @extracted_user.memberships.where(membership_status: "founder").map do |membership|
                membership.athlete_platform
            end.uniq
            
            limited_athlete_platforms = @account_checker.return_limited_resources(:athlete_platforms, athlete_platforms)
            
            render json: serialize_athlete_platforms(limited_athlete_platforms), status: :ok
        end    
        
        def show
            render json: serialize_full_athlete_platform(@current_athlete_platform, @hash_to_merge), status: :ok
        end

        def create
            athlete_platform = @extracted_user.create_athlete_platform_as_founder(athlete_platform_params)

            render json: serialize_athlete_platform(athlete_platform), status: :ok
        end

        def update
            @current_athlete_platform.update!(athlete_platform_params)
            
            render json: serialize_athlete_platform(@current_athlete_platform), status: :ok
        end

        def destroy
            @current_athlete_platform.destroy

            PlatformChat.find_by(athlete_platform_id: @current_athlete_platform.id).destroy

            render json: {message: "Athlete platform was successfully deleted"}, status: :ok
        end

        private

            def athlete_platform_params
                params.permit(:athlete_name, :athlete_phone_number, :athlete_email, :athlete_sport_discipline, :athlete_age,
                            :athlete_height, :athlete_weight, :athlete_arm, :athlete_chest, :athlete_waist, :athlete_hips,
                            :athlete_tigh, :fitness_level)
            end

            def current_athlete_platform
                current_athlete_platform = @extracted_user.athlete_platforms.find(params[:id])

                membership = current_athlete_platform.memberships.where(user_id: @extracted_user.id).first
                if membership != nil
                    if membership.membership_status == "founder"
                        @current_athlete_platform = current_athlete_platform
                    else
                        raise ActiveRecord::RecordNotFound
                    end
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
                @error_creator = Errorer::ErrorCreator.new(:athlete_platforms)
            end

            def return_athlete_status
                attendant_memberships = @current_athlete_platform.memberships.where(membership_status: 'attendant')
                invitations = @current_athlete_platform.invitations
                pending_user_invitations = @current_athlete_platform.pending_user_invitations

                if attendant_memberships.count == 1
                    attendant_membership = attendant_memberships.first
                    
                    if attendant_membership.user != nil
                        auth_sub = attendant_membership.user.auth_sub
                    end

                    @management_token = ManagementToken.new.get_token.second

                    output = AuthZeroHelper.new(@management_token)
                                    .get_user_from_auth(auth_sub)

                    if output.first == 'ok'
                        @hash_to_merge = {
                            attendant_membership: {
                                id: attendant_memberships.first.id,
                                athlete_email: output.second['email']
                            }
                        }
                    else
                        render json: @error_creator.create_error(500, 2), status: 500
                    end
                elsif invitations.count == 1
                    @management_token = ManagementToken.new.get_token.second
                    
                    output = AuthZeroHelper.new(@management_token)
                                    .get_user_from_auth(invitations.first.recipient_id)
                    
                    if output.first == 'ok'
                        @hash_to_merge = {
                            invitation: {
                                id: invitations.first.id,
                                athlete_email: output.second['email']
                            }
                        }
                    else
                        render json: @error_creator.create_error(500, 3), status: 500
                    end
                elsif pending_user_invitations.count == 1
                    pending_user_invitation = pending_user_invitations.first
                    @hash_to_merge = {
                        pending_user_invitation: {
                            id: pending_user_invitation.id, 
                            athlete_email: pending_user_invitation.athlete_identifier
                        }
                    }
                else
                    @hash_to_merge = {}
                end
            end

            def check_access_to_make_athlete_platforms
                if @account_checker.permitted_to_make_athlete_platform? == false
                    render json: @error_creator.create_error(403, 1), status: 403
                end
            end
    end

end

# Controller for role: trainer.