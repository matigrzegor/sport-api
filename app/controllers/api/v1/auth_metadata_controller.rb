module Api::V1

    class AuthMetadataController < ApplicationController
        include Secured
        include AthleteRoled
        include Api::V1::AuthMetadataErrorer
        before_action :management_token, only: :create

        def create
            if auth_metadata_params[:metadata_type] == 'training_plan_last_id'
                response = create_training_plan_last_id_metadata_in_auth

                if response.code == 200
                    render json: {message: "Metadata was successfully created"}
                else
                    render json: auth0_error_one, status: 500
                end
            elsif auth_metadata_params[:metadata_type] == 'athlete_platform_last_id'
                response = create_athlete_platform_last_id_metadata_in_auth
                
                if response.code == 200
                    render json: {message: "Metadata was successfully created"}
                else
                    render json: auth0_error_two, status: 500
                end
            elsif auth_metadata_params[:metadata_type] == 'tags'
                response = create_tags_metadata_in_auth
                
                if response.code == 200
                    render json: {message: "Metadata was successfully created"}
                else
                    render json: auth0_error_two, status: 500
                end
            else
                render json: validation_error_one, status: :bad_request
            end
        end
    
        private

            def auth_metadata_params
                params.permit(:metadata_type, :training_plan_last_id, :athlete_platform_last_id,
                                :first_training_session, :second_training_session, :third_training_session)
            end
            
            def management_token
                management_array = ManagementToken.new.get_token
                if management_array.first == 'token'
                    @management_token = management_array.second
                elsif management_array.first == 'error'
                    render json: auth0_management_token_error, status: 500
                end
            end

            def create_training_plan_last_id_metadata_in_auth
                HTTP.auth("Bearer #{@management_token}")
                    .patch("#{ENV['AUTHO_DOMAIN']}/api/v2/users/#{@extracted_user.auth_sub}",
                            json: { user_metadata: { training_plan_last_id: 
                                                    auth_metadata_params[:training_plan_last_id] }})
            end

            def create_athlete_platform_last_id_metadata_in_auth
                HTTP.auth("Bearer #{@management_token}")
                    .patch("#{ENV['AUTHO_DOMAIN']}/api/v2/users/#{@extracted_user.auth_sub}",
                            json: { user_metadata: { athlete_platform_last_id: 
                                                    auth_metadata_params[:athlete_platform_last_id] }})
            end

            def create_tags_metadata_in_auth
                data_hash = {
                    tags: {
                        first_training_session: auth_metadata_params[:first_training_session],
                        second_training_session: auth_metadata_params[:second_training_session],
                        third_training_session: auth_metadata_params[:third_training_session]
                    }
                }
                
                HTTP.auth("Bearer #{@management_token}")
                    .patch("#{ENV['AUTHO_DOMAIN']}/api/v2/users/#{@extracted_user.auth_sub}",
                            json: { user_metadata: data_hash})
            end

    end

end

# Controller for role: trainer.
# -----------------------------------------------------------------------
# Metadata in auth0 stores the information about the last training plan and the last athlete_platform the trainer
# used. And also tags.
# -----------------------------------------------------------------------
# I treat metadata in auth0 as resources like tiles resources, athlete_platforms resources in my application.
# The differance is that metadata is stored in auth0 and tiles or athlete_platforms are stored in my databse.
# -----------------------------------------------------------------------
# From the data in json, create action knows what type of metadatum to create in auth0.
# -----------------------------------------------------------------------
# This controller uses ManagementToken lib to get access token for auth0.
# -----------------------------------------------------------------------
