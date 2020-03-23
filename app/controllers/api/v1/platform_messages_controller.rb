module Api::V1

    class PlatformMessagesController < ApplicationController
        include ChatSecured
        include Api::V1::PlatformMessageSerializer
        before_action :current_platform_chat, only: [:create, :index]

        def create
            platform_message = @current_platform_chat.platform_messages.create!(create_params)

            render json: serialize_platform_message(platform_message), status: 200
        end

        def index
            platform_messages = @current_platform_chat.platform_messages.fetch_messages(fetch_number)

            render json: serialize_platform_messages(platform_message), status: 200
        end


        private

            def create_params
                {
                    user_auth_sub: @auth_sub,
                    message_date: params.dig(:message_date),
                    message_text: params.dig(:message_text)
                }
            end

            def fetch_number
                params.dig(:fetch_number)
            end
            
            def current_platform_chat
                current_platform_chat = PlatformChat.find(params[:platform_chat_id])
                
                if current_platform_chat.athlete_auth_sub == @auth_sub || current_platform_chat.trainer_auth_sub == @auth_sub
                    @current_platform_chat = current_platform_chat
                else
                    render json: Errorer::ErrorCreator.new(:platform_messages).create_error(403, 1)
                end
            end
    end

end

# Controller for all roles.