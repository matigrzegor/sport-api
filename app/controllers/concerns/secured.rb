module Secured
    extend ActiveSupport::Concern

    included do
        before_action :authenticate_request!
    end

    private

    def authenticate_request!
        initialize_error_creator
        
        @auth_payload, @auth_header = auth_token
        
        extract_from_auth_token   

    rescue JWT::VerificationError, JWT::DecodeError
        render json: @error_creator.create_error(401, 1), status: 401
    end

    def extract_from_auth_token
        auth_sub = @auth_payload['sub']
        
        extracted_user = User.find_by(auth_sub: auth_sub)
        
        if extracted_user != nil
            @extracted_user = extracted_user
        else
            new_user = User.create!(auth_sub: auth_sub)
            @extracted_user = new_user
        end

        account_checker = AccountLevel::Checker.new(@extracted_user)

        if account_checker.user_permitted == true
            @account_checker = account_checker
        elsif account_checker.user_permitted == false
            action_to_be_performed = account_checker.action_to_be_performed

            render json: @error_creator.create_specific_error(action_to_be_performed), status: 403
        end
    end    
    
    def http_token
        if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
        end
    end

    def auth_token
        JsonWebToken.verify(http_token)
    end

    def initialize_error_creator
        @error_creator = Errorer::ErrorCreator.new(:secured)
    end
end

