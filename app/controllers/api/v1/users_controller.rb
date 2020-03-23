module Api::V1

    class UsersController < ApplicationController
        include Secured
        include AthleteRoled
        before_action :management_token, only: :destroy
        before_action :error_creator, only: :destroy

        def destroy
            output = AuthZeroHelper.new(@management_token)
                        .delete_user_from_auth(@extracted_user.auth_sub)
        
            if output[:status] == :ok
                @extracted_user.destroy
            else
                render json: @error_creator.create_error(500, 1), status: 500
            end
        end
     

        private

            def management_token
                management_array = ManagementToken.new.get_token
                if management_array.first == 'token'
                    @management_token = management_array.second
                elsif management_array.first == 'error'
                    render json: @error_creator.create_specific_error(:auth0_management_token_error), status: 500
                end
            end

            def error_creator
                @error_creator = Errorer::ErrorCreator.new(:users)
            end
    end

end

# Controller for all roles.