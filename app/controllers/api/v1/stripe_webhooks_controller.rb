module Api::V1

    class StripeWebhooksController < ApplicationController
        before_action :return_stripe_event_data, only: :stripe_event
        before_action :error_creator, only: :stripe_event
        before_action :management_token, only: :stripe_event
        
        def stripe_event
            case @event_type
            when 'invoice.payment_succeeded'
                invoice = @event_data.object
                paid_periods = invoice.lines.data[0].period
                plan_id = invoice.lines.data[0].plan.id
                customer_id = invoice.customer
                extracted_user = User.find_by(stripe_customer_id: customer_id)

                if extracted_user != nil
                    account_level_data_processor = AccountLevel::AccountLevelDataProcessor.new(@management_token, extracted_user.auth_sub)

                    output = account_level_data_processor.create_subscription(:event_sustain, paid_periods, plan_id, customer_id)
                    
                    if output.first == 'ok'
                        render json: {'message' => 'ok'}, status: 200
                    else
                        render json: @error_creator.create_error(400, 2), status: 400
                    end
                else
                    render json: @error_creator.create_error(400, 3), status: 400
                end
                
            when 'invoice.payment_failed'
                invoice = @event_data.object
                customer_id = invoice.customer
                extracted_user = User.find_by(stripe_customer_id: customer_id)

                if extracted_user != nil
                    auth_helper = AuthZeroHelper.new(@management_token)
                    
                    output = auth_helper.send_user_payment_failure_notification_in_auth(extracted_user.auth_sub)

                    if output[:status] == :ok
                        render json: {'message' => 'ok'}, status: 200
                    else
                        render json: @error_creator.create_error(400, 6), status: 400
                    end
                else
                    render json: @error_creator.create_error(400, 5), status: 400
                end
            #when 'customer.subscription.deleted'
            #    subscription = @event_data.object
            #    customer_id = subscription.customer
            #    extracted_user = User.find_by(stripe_customer_id: customer_id)
            #
            #    if extracted_user != nil
            #        account_level_data_processor = AccountLevel::AccountLevelDataProcessor.new(@management_token, extracted_user.auth_sub)
            #
            #        output = account_level_data_processor.cancel_subscription(:cancel_from_event)
            #
            #        if output.first == 'ok'
            #            render json: {'message' => 'ok'}, status: 200
            #        else
            #            render json: @error_creator.create_error(400, 4), status: 400
            #        end
            #    else
            #        render json: @error_creator.create_error(400, 7), status: 400
            #    end
            else
                render json: @error_creator.create_error(400, 1), status: 400
            end
        end

        private

            def return_stripe_event_data
                payload = request.body.read
                sig_header = request.env['HTTP_STRIPE_SIGNATURE']
                endpoint_secret = ENV['STRIPE_SIGNING_SECRET']
                
                event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)

                @event_type = event.type
                @event_data = event.data

            rescue JSON::ParserError => e
                render json: @error_creator.create_error(400, 1), status: 400
            rescue Stripe::SignatureVerificationError => e
                render json: @error_creator.create_error(400, 1), status: 400
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
                @error_creator = Errorer::ErrorCreator.new(:trials)
            end
    
    end

end