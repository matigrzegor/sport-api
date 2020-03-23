module Api::V1

    class StripeSubscriptionsController < ApplicationController
        include Secured
        include AthleteRoled
        before_action :error_creator, only: [:create_first_subscription, :cancel_subscription,
                                             :create_subscription, :update_subscription,
                                             :preview_proration, :update_subscription, :reattempt_payment]
        before_action :management_token, only: [:create_first_subscription, :cancel_subscription,
                                                :create_subscription, :update_subscription,
                                                :preview_proration, :update_subscription, :reattempt_payment]

		def create_first_subscription
			stripe_processor = AccountLevel::StripeProcessor.new(@management_token, @extracted_user)
            
            if stripe_processor.prepared_to_process == true
                output = stripe_processor.user_initial_subscription_create(stripe_subscription_params)
                    
                if output.first == 'ok'
                    render json: {account_level_data: output.second}, status: :ok
                elsif output.first == 'error' && output.second == 2
                    render json: @error_creator.create_error(400, 1), status: 400
                elsif output.first == 'error' && output.second == 1
                    render json: {message: 'Payment failed'}, status: 200
                elsif output.first == 'error' && output.second == 0
                    render json: {message: 'Payment failed'}, status: 200
                elsif output.first == 'error' && output.second == 3
                    render json: @error_creator.create_error(500, 4), status: 500
                elsif output.first == 'error' && output.second == 4
                    render json: @error_creator.create_error(404, 5), status: 404
                elsif output.first == 'error' && output.second == 5
                    render json: @error_creator.create_error(500, 6), status: 500
                elsif output.first == 'error' && output.second == 6
                    render json: @error_creator.create_error(500, 7), status: 500
                end
            else
                render json: @error_creator.create_error(500, 8), status: 500
            end
		end
        
        def cancel_subscription
            stripe_processor = AccountLevel::StripeProcessor.new(@management_token, @extracted_user)
            
            if stripe_processor.prepared_to_process == true
                output = stripe_processor.user_subscription_cancel
                
                if output.first == 'ok'
                    render json: {account_level_data: output.second}, status: :ok
                elsif output.first == 'error' && output.second == 0
                    render json: @error_creator.create_error(404, 1), status: 404
                elsif output.first == 'error' && output.second == 1
                    render json: @error_creator.create_error(500, 2), status: 500
                elsif output.first == 'error' && output.second == 2
                    render json: @error_creator.create_error(404, 3), status: 404
                elsif output.first == 'error' && output.second == 3
                    render json: @error_creator.create_error(500, 4), status: 500
                elsif output.first == 'error' && output.second == 4
                    render json: @error_creator.create_error(500, 5), status: 500
                elsif output.first == 'error' && output.second == 5
                    render json: @error_creator.create_error(500, 6), status: 500
                elsif output.first == 'error' && output.second == 6
                    render json: @error_creator.create_error(500, 7), status: 500
                end
            else
                render json: @error_creator.create_error(500, 8), status: 500
            end
        end

        def create_subscription
            stripe_processor = AccountLevel::StripeProcessor.new(@management_token, @extracted_user)
            
            if stripe_processor.prepared_to_process == true
                output = stripe_processor.user_subscription_create(stripe_subscription_params)
                    
                if output.first == 'ok'
                    render json: {account_level_data: output.second}, status: :ok
                elsif output.first == 'error' && output.second == 0
                    render json: @error_creator.create_error(400, 1), status: 400
                elsif output.first == 'error' && output.second == 1
                    render json: @error_creator.create_error(500, 2), status: 500
                elsif output.first == 'error' && output.second == 2
                    render json: @error_creator.create_error(404, 3), status: 404
                elsif output.first == 'error' && output.second == 3
                    render json: @error_creator.create_error(500, 4), status: 500
                elsif output.first == 'error' && output.second == 4
                    render json: {message: 'Payment failed'}, status: 200
                elsif output.first == 'error' && output.second == 5
                    render json: @error_creator.create_error(500, 6), status: 500
                elsif output.first == 'error' && output.second == 6
                    render json: @error_creator.create_error(404, 7), status: 404
                elsif output.first == 'error' && output.second == 7
                    render json: @error_creator.create_error(500, 9), status: 500
                elsif output.first == 'error' && output.second == 8
                    render json: {message: 'Payment failed'}, status: 200
                end
            else
                render json: @error_creator.create_error(500, 8), status: 500
            end
        end

        def preview_proration
            stripe_processor = AccountLevel::StripeProcessor.new(@management_token, @extracted_user)
            
            if stripe_processor.prepared_to_process == true
                output = stripe_processor.user_preview_proration(stripe_subscription_params)
                    
                if output.first == 'ok'
                    render json: {proration: output.second}, status: :ok
                elsif output.first == 'error' && output.second == 0
                    render json: @error_creator.create_error(400, 1), status: 400
                elsif output.first == 'error' && output.second == 1
                    render json: @error_creator.create_error(500, 2), status: 500
                elsif output.first == 'error' && output.second == 2
                    render json: @error_creator.create_error(404, 3), status: 404
                elsif output.first == 'error' && output.second == 3
                    render json: @error_creator.create_error(500, 4), status: 500
                end
            else
                render json: @error_creator.create_error(500, 5), status: 500
            end
        end

        def update_subscription
            stripe_processor = AccountLevel::StripeProcessor.new(@management_token, @extracted_user)
            
            if stripe_processor.prepared_to_process == true
                output = stripe_processor.user_subscription_update(stripe_subscription_params)
                    
                if output.first == 'ok' 
                    render json: {account_level_data: output.second}, status: :ok
                elsif output.first == 'error' && output.second == 0
                    render json: @error_creator.create_error(400, 1), status: 400
                elsif output.first == 'error' && output.second == 1
                    render json: @error_creator.create_error(500, 2), status: 500
                elsif output.first == 'error' && output.second == 2
                    render json: @error_creator.create_error(404, 3), status: 404
                elsif output.first == 'error' && output.second == 3
                    render json: @error_creator.create_error(500, 4), status: 500
                end
            else
                render json: @error_creator.create_error(500, 5), status: 500
            end
        end

        def reattempt_payment
            stripe_processor = AccountLevel::StripeProcessor.new(@management_token, @extracted_user)
            
            if stripe_processor.prepared_to_process == true
                output = stripe_processor.user_reattempt_payment(stripe_subscription_params)
                    
                if output.first == 'ok'
                    render json: {account_level_data: output.second}, status: :ok
                elsif output.first == 'error' && output.second == 0
                    render json: @error_creator.create_error(400, 1), status: 400
                elsif output.first == 'error' && output.second == 1
                    render json: @error_creator.create_error(500, 2), status: 500
                elsif output.first == 'error' && output.second == 2
                    render json: @error_creator.create_error(404, 3), status: 404
                elsif output.first == 'error' && output.second == 3
                    render json: @error_creator.create_error(500, 4), status: 500
                elsif output.first == 'error' && output.second == 4
                    render json: {message: 'Payment failed'}, status: 200
                elsif output.first == 'error' && output.second == 5
                    render json: @error_creator.create_error(500, 6), status: 500
                elsif output.first == 'error' && output.second == 6
                    render json: @error_creator.create_error(404, 7), status: 404
                elsif output.first == 'error' && output.second == 7
                    render json: @error_creator.create_error(500, 9), status: 500
                end
            else
                render json: @error_creator.create_error(500, 8), status: 500
            end
        end

		private

			def stripe_subscription_params
                params.require(:stripe_data).permit(:email, :source, :plan, :name, :phone,
                                                     address: [:line1, :city, :country, :postal_code, :state])
			end

			def management_token
                management_array = ManagementToken.new.get_token
                if management_array.first == 'token'
                    @management_token = management_array.second
                elsif management_array.first == 'error'
                    render json: @error_creator.create_specific_error(:auth0_management_token_error), status: 500
                end
            end

            def error_creator
                @error_creator = Errorer::ErrorCreator.new(:stripe_subscriptions)
            end
		
	end

end