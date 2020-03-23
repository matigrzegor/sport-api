class ManagementToken

    def get_token    
        if get_token_from_auth == 200
            ['token', @token]
        else
            ['error', @message]
        end
    end

    private

        def get_token_from_auth
            response = HTTP.post("#{ENV['AUTHO_DOMAIN']}/oauth/token",
                    :json => {grant_type: "client_credentials",
                                client_id: ENV['AUTHO_CLIENT_ID'],
                                client_secret: ENV['AUTHO_CLIENT_SECRET'],
                                audience: ENV['AUTHO_AUDIENCE']})
        
            if response.code == 200
                @token = response.parse['access_token']
            else
                @message = response.parse['message']
            end
            response.code
        end
end


# This library is meant to get an access token form auth0 to aceess auth0 management api.
# We access auth0 management api to for example modify user's data.