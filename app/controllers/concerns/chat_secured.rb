module ChatSecured
    extend ActiveSupport::Concern

    included do
        before_action :authenticate_request!
    end

    private

        def authenticate_request!
            auth_payload, auth_header = auth_token
            
            @auth_sub = auth_payload['sub']   

        rescue JWT::VerificationError, JWT::DecodeError
            render json: Errorer::ErrorCreator.new(:secured).create_error(401, 1), status: 401
        end   
        
        def http_token
            if request.headers['Authorization'].present?
                request.headers['Authorization'].split(' ').last
            end
        end

        def auth_token
            JsonWebToken.verify(http_token)
        end

end
