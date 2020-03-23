class AuthZeroHelper

    def initialize(management_token)
        @management_token = management_token
    end

    def check_whether_account_already_exist(email)
        user_email = email.downcase
        array_of_users = HTTP.auth("Bearer #{@management_token}")
            .get("#{ENV['AUTHO_DOMAIN']}/api/v2/users-by-email?email=#{user_email}")
        
        if array_of_users.code == 200
            validated_users = array_of_users.parse.map do |elem|
                if elem['email'] == user_email
                    elem
                else
                    nil
                end
            end.compact
            
            users_data = validated_users.map do |validated_user|
                {
                    nickname: validated_user['nickname'],
                    picture: validated_user['picture'],
                    user_id: validated_user['user_id']
                }
            end

            users_count = validated_users.count

            if users_count == 0
                {status: :ok, user_exist: false}
            elsif users_count == 1
                {status: :ok, user_exist: true, users_data: users_data}
            elsif users_count > 1
                {status: :ok, user_exist: true, users_data: users_data}
            end
        else
            ['error', array_of_users.code]
        end
    end

    def get_user_from_auth(user_id)
        response = HTTP.auth("Bearer #{@management_token}")
            .get("#{ENV['AUTHO_DOMAIN']}/api/v2/users/#{user_id}")

        if response.code == 200
            ['ok', response.parse]
        else
            ['error', response.parse]
        end
    end

    def send_user_payment_failure_notification_in_auth(user_id)
        output = HTTP.auth("Bearer #{@management_token}")
                            .patch("#{ENV['AUTHO_DOMAIN']}/api/v2/users/#{user_id}",
                                    json: { app_metadata: { payment_failure_status: 'failure'}})
        
        if output.code == 200
            {status: :ok}
        else
            {status: :error}
        end  
    end

    def remove_user_payment_failure_notification_in_auth(user_id)
        output = HTTP.auth("Bearer #{@management_token}")
                            .patch("#{ENV['AUTHO_DOMAIN']}/api/v2/users/#{user_id}",
                                    json: { app_metadata: { payment_failure_status: 'no-failure'}})
        
        if output.code == 200
            {status: :ok}
        else
            {status: :error}
        end  
    end

    def delete_user_from_auth(user_id)
        output = HTTP.auth("Bearer #{@management_token}")
                            .delete("#{ENV['AUTHO_DOMAIN']}/api/v2/users/#{user_id}")
        
        if output.code == 204
            {status: :ok}
        else
            {status: :error, message: output.message}
        end
    end

end


# Helper library for auth0.