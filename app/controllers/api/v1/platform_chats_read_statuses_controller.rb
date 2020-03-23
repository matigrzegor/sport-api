module Api::V1

    class PlatformChatsReadStatusesController < ApplicationController
        include ChatSecured
        include Api::V1::PlatformMessageSerializer
        
        
        def index
            trainer_auth_sub = @auth_sub
            athlete_auth_sub = @auth_sub
            
            platform_chats = PlatformChat.where("trainer_auth_sub = ? or athlete_auth_sub = ?",
                                                    trainer_auth_sub, athlete_auth_sub)

            data_to_serialize = []

            platform_chats.each do |platform_chat|
                last_platform_message = platform_chat.platform_messages.last
                
                if last_platform_message.user_auth_sub != @auth_sub && last_platform_message.message_read == false
                    if platform_chat.trainer_auth_sub == @auth_sub
                        
                        read_status_data = {
                            id: platform_chat.id,
                            athlete_username: platform_chat.athlete_username,
                            athlete_avatar: platform_chat.athlete_avatar,
                            message_date: last_platform_message.message_date,
                            message_text: last_platform_message.message_text
                        }

                        data_to_serialize << read_status_data
                    else
                        
                        read_status_data = {
                            id: platform_chat.id,
                            trainer_username: platform_chat.trainer_username,
                            trainer_avatar: platform_chat.trainer_avatar,
                            message_date: last_platform_message.message_date,
                            message_text: last_platform_message.message_text
                        }

                        data_to_serialize << read_status_data
                    end
                end
            end


            render json: data_to_serialize, status: 200
        end


    end

end

# Controller for all roles.