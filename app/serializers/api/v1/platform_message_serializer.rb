module Api::V1

    module PlatformMessageSerializer

        def serialize_message(message)
            {
                user_id: message.user_auth_sub,
                message_date: message.message_date,
                message_text: message.message_text
            }
        end
    
        def serialize_messages(messages)
            messages.map do |message|
                serialize_message(message)
            end
        end
    
    end

end