module Api::V1

    class UserAccountSearchesController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::UserAccountSearchErrorer
        before_action :management_token, only: :create

        def create
            output = AuthZeroHelper.new(@management_token)
                    .check_whether_account_already_exist(user_account_search_params[:user_email])
        
            if output[:status] == :ok
                if output[:user_exist] == true
                    data_hash = output.slice(:user_exist, :users_count, :users_data)
                    
                    render json: data_hash, status: :ok
                elsif output[:user_exist] == false
                    data_hash = output.slice(:user_exist)
                    
                    render json: data_hash, status: :ok
                end
            else
                render json: auth0_error_one, status: 500
            end
        end
     

        private

            def user_account_search_params
                permited = params.permit(:user_email)
                {user_email: String(permited[:user_email])}
            end

            def management_token
                management_array = ManagementToken.new.get_token
                if management_array.first == 'token'
                    @management_token = management_array.second
                elsif management_array.first == 'error'
                    render json: auth0_management_token_error, status: 500
                end
            end
    end

end

# Controller for role: trainer.