module AccountLevel
	
	class StripeProcessor
		attr_reader :prepared_to_process, :processor_possibilities,
					:error_message

		def initialize(management_token, extracted_user)
			@management_token = management_token
			@extracted_user = extracted_user
			Stripe.api_key = ENV['STRIPE_SECRET_KEY']
			output = return_processor_possibilities
			if output.first == 'ok'
				@prepared_to_process = true
				@processor_possibilities = output.second
				@user_body = output.last
			elsif output.first == 'error'
				@prepared_to_process = false
				@error_message == output.second
			end
		end
		 
		def user_initial_subscription_create(input_data)	
			if @processor_possibilities.include?(:user_initial_subscription_create)
				if input_data != nil
					@input_data = input_data
				end

				@customer_data = return_customer_data_to_create
					
				first_output = create_customer_in_stripe
				
				if first_output.first == 'ok'
					@customer_id = first_output.second['id']
					@subscription_data = return_subscription_data_to_create
					
					@extracted_user.stripe_customer_id = @customer_id
                    @extracted_user.save!

					second_output = create_subscription_in_stripe
					
					if second_output.first == 'ok'
						user_id = @extracted_user.auth_sub

						subscription_body = second_output.second
						customer_id = @customer_id
						plan_id = @input_data[:plan]				

						output = AccountLevel::AccountLevelDataProcessor.new(@management_token, user_id, @user_body)
									.create_subscription(:initial_create, subscription_body, plan_id, customer_id)
											
						
						if output.first == 'ok'
							['ok', output.second]
						elsif output.first == 'error' && output.second == 0
							['error', 3]
						elsif output.first == 'error' && output.second == 1
							['error', 4]
						elsif output.first == 'error' && output.second == 2
							['error', 5]
						end
					elsif second_output.first == 'error' && second_output.second == 0
						['error', 1, second_output.last]
					elsif second_output.first == 'error' && second_output.second == 1
						['error', 2]
					end
						
				elsif first_output.first == 'error'
					['error', 0]
				end
			else
				['error', 6]
			end
		end

		def user_subscription_cancel
			if @processor_possibilities.include?(:user_subscription_cancel)
				output_first = get_subscription_id_from_stripe

				if output_first.first == 'ok'
					@subscription_id = output_first.second

					output_second = cancel_subscription_in_stripe

					if output_second.first == 'ok'
						user_id = @extracted_user.auth_sub
						
						output_third = AccountLevel::AccountLevelDataProcessor.new(@management_token, user_id, @user_body)
									.cancel_subscription(:cancel_from_user)


						if output_third.first == 'ok'
							['ok', output_third.second]
						elsif output_third.first == 'error' && output_third.second == 0
							['error', 4]
						elsif output_third.first == 'error' && output_third.second == 1
							['error', 5]
						elsif output_third.first == 'error' && output_third.second == 2
							['error', 6]
						end

					else
						['error', 3, output.second]
					end
				elsif output_first.first == 'error' && output_first.second == 0
					['error', 1, output.last]
				elsif output_first.first == 'error' && output_first.second == 1
					['error', 2]
				end
			else
				['error', 0]
			end
		end

		def user_subscription_create(input_data)
			if @processor_possibilities.include?(:user_subscription_create)
				@input_data = input_data
				
				output_first = get_subscriptions_from_stripe

				if output_first.first == 'ok'
					subscriptions = output_first.second

					if subscriptions['total_count'] == 0
						
						@customer_data = return_customer_data_to_update
						
						output_third = update_customer_in_stripe
						
						if output_third.first == 'ok'
							@subscription_data = return_subscription_data_to_create
							
							output_second = create_subscription_in_stripe

							if output_second.first == 'ok'
								user_id = @extracted_user.auth_sub

								subscription_body = output_second.second
								plan_id = @input_data[:plan]

								output = AccountLevel::AccountLevelDataProcessor.new(@management_token, user_id, @user_body)
										.create_subscription(:following_create, subscription_body, plan_id)
												
							
								if output.first == 'ok'
									['ok', output.second]
								elsif output.first == 'error' && output.second == 0
									['error', 5]
								elsif output.first == 'error' && output.second == 1
									['error', 6]
								elsif output.first == 'error' && output.second == 2
									['error', 7]
								end

							elsif output_second.first == 'error' && output_second.second == 0
								['error', 3]
							elsif output_second.first == 'error' && output_second.second == 1
								['error', 4]
							end
						elsif output_third.first == 'error'
							['error', 8]
						end
					else
						['error', 2]
					end

				else
					['error', 1]
				end
			else
				['error', 0]
			end
		end

		def user_preview_proration(input_data)
			if @processor_possibilities.include?(:user_preview_proration)
				proration_date = Time.now.to_i
				
				output = get_subscriptions_from_stripe

				if output.first == 'ok'
					subscriptions = output.second

					if subscriptions.total_count == 1
						subscription = subscriptions.data.first

						items = [{id: subscription.items.data[0].id,
								  plan: input_data[:plan]}]
							
						invoice = Stripe::Invoice.upcoming({customer: @customer_id, subscription: subscription.id,
											subscription_items: items, subscription_proration_date: proration_date})
							
						current_prorations = invoice.lines.data.select { |ii| ii.period.start == proration_date }
						cost = 0
						
						current_prorations.each do |p|
							cost += p.amount
						end
					
						['ok', cost]
					else
						['error', 2]
					end
				else
					['error', 1]
				end

			else
				['error', 0]
			end
		rescue Stripe::InvalidRequestError => e
			['error', 3]
		end

		def user_subscription_update(input_data)
			if @processor_possibilities.include?(:user_subscription_update)
				output_first = get_subscription_id_from_stripe

				if output_first.first == 'ok'
					@subscription_id = output_first.second
					@plan_id = input_data[:plan]
					@sub_item_id = output_first.last

					output_second = update_subscription_in_stripe

					if output_second.first == 'ok'
						user_id = @extracted_user.auth_sub
						
						subscription_body = output_second.second

						output = AccountLevel::AccountLevelDataProcessor.new(@management_token, user_id, @user_body)
										.update_subscription(@plan_id)
										
					
						if output.first == 'ok'
							['ok', output.second, output.last]
						elsif output.first == 'error' && output.second == 0
							['error', 4]
						elsif output.first == 'error' && output.second == 1
							['error', 5]
						elsif output.first == 'error' && output.second == 2
							['error', 6]
						end
					else
						['error', 3]
					end

				elsif output_first.first == 'error' && output_first.second == 0
					['error', 1, output.last]
				elsif output_first.first == 'error' && output_first.second == 1
					['error', 2]
				end
			else
				['error', 0]
			end
		end

		def user_reattempt_payment(input_data)
			@customer_id = @extracted_user.stripe_customer_id
			@input_data = input_data
			@cutomer_data = return_customer_data_to_update.slice(:source)

			output_first = update_customer_in_stripe

			if output_first.first == 'ok'

				output_second = get_subscription_id_from_stripe

				if output_second.first == 'ok'
					subscription = output_second.third

					@latest_invoice_id = subscription.latest_invoice.id

					output_third = pay_latest_invoice

					if output_third.first == 'ok'
						payment_intent_status = output_third.second.payment_intent.status

						if payment_intent_status == 'succeeded'
							user_id = @extracted_user.auth_sub
							plan_id = subscription.plan.id

							output = AccountLevel::AccountLevelDataProcessor.new(@management_token, user_id, @user_body)
										.create_subscription(:following_create, subscription, plan_id)

							auth_helper = AuthZeroHelper.new(@management_token)
                    		auth_helper.remove_user_payment_failure_notification_in_auth(user_id)

							if output.first == 'ok'
								['ok', output.second]
							elsif output.first == 'error' && output.second == 0
								['error', 5]
							elsif output.first == 'error' && output.second == 1
								['error', 6]
							elsif output.first == 'error' && output.second == 2
								['error', 7]
							end
						elsif payment_intent_status == 'requires_payment_method'
							['error', 4]
						end
					else
						['error', 3]
					end
				elsif output_second.first == 'error' && output_second.second == 0
					['error', 1]
				elsif output_second.first == 'error' && output_second.second == 1
					['error', 2]
				end
			else
				['error', 0]
			end
		end

		private

			def return_processor_possibilities
				output = AuthZeroHelper.new(@management_token).get_user_from_auth(@extracted_user.auth_sub)

				if output.first == 'ok'
					user_body = output.second
					
					output_array = ['ok']
					
					if user_body['app_metadata'] != nil
						account_level_data = user_body['app_metadata']['account_level_data']
						
						if account_level_data != nil
							stripe_customer_id = account_level_data['stripe_customer_id']
							
							if stripe_customer_id != nil
								output_array << [:user_subscription_cancel, :user_subscription_create, 
												 :user_preview_proration, :user_subscription_update]

								@customer_id = stripe_customer_id
							else
								output_array << [:user_initial_subscription_create]
							end
						else
							output_array << [:user_initial_subscription_create]
						end
					
					else
						output_array << [:user_initial_subscription_create]
					end

					output_array << user_body

					output_array
				else
					['error', output.second]
				end
			end

			def return_customer_data_to_create
				customer_data = @input_data.slice(:email, :source, :address, :name, :phone)
			
				input_address = customer_data[:address]
				
				if input_address != nil
					@address_hash = {
						line1: input_address[:line1],
						city: input_address[:city],
						country: input_address[:country],
						postal_code: input_address[:postal_code],
						state: input_address[:state]
					}
				end

				data_hash = {
					address: @address_hash,
					name: String(customer_data[:name]),
					phone: String(customer_data[:phone]),
					email: String(customer_data[:email]),
					source: String(customer_data[:source])
				}	

				data_hash		
			end
			
			def return_subscription_data_to_create
				subscription_data = @input_data.slice(:plan)
			
				if @customer_id != nil
					{
						customer: String(@customer_id),
					 	default_tax_rates: ['txr_1GOjTIG0o8wns6uJarWIP7TS'],
						items: [{plan: String(subscription_data[:plan])},],
						expand: ['latest_invoice.payment_intent']
					}
				end
			end

			def return_customer_data_to_update
				customer_data = {}
						
				if @input_data[:phone] != ''
					customer_data.merge!(phone: @input_data[:phone])
				end

				if @input_data[:name] != ''
					customer_data.merge!(name: @input_data[:name])
				end 

				if @input_data[:source] != ''
					customer_data.merge!(source: @input_data[:source])
				end

				address_data = {}

				input_address = @input_data[:address]

				if input_address != nil
					if input_address[:line1] != ''
						address_data.merge!(line1: input_address[:line1])
					#else
					#	output = get_customer_form_stripe
					#
					#	if output.first == 'ok'
					#		address_data.merge!(line1: output.second.address.line1)
					#	end
					end

					if input_address[:city] != ''
						address_data.merge!(city: input_address[:city])
					end
					
					if input_address[:country] != ''
						address_data.merge!(country: input_address[:country])
					end
					
					if input_address[:postal_code] != ''
						address_data.merge!(postal_code: input_address[:postal_code])
					end
					
					if input_address[:state] != ''
						address_data.merge!(state: input_address[:state])
					end
				end
				
				customer_data.merge!(address: address_data)

				customer_data
			end

			def pay_latest_invoice
				response = Stripe::Invoice.pay({invoice: @latest_invoice_id, expand: ['payment_intent']})
			
				['ok', response]
			rescue => e
				['error', e.message]
			end
		
			def create_customer_in_stripe
				response = Stripe::Customer.create(@customer_data)
		                    
				['ok', response]		
			rescue => e
				['error', e.message]
			end

			def update_customer_in_stripe
				response = Stripe::Customer.update(@customer_id, @customer_data)
				
				['ok', response]		
			rescue => e
				['error', e.message]
			end

			def create_subscription_in_stripe
				response = Stripe::Subscription.create(@subscription_data)
		                    
				response_body = response
				
				if response_body['latest_invoice'] != nil
					if response_body['latest_invoice']['payment_intent'] != nil
						interpretation = interpret_statuses([response_body['status'],
															 response_body['latest_invoice']['payment_intent']['status']])
											
						
						if interpretation == 'success'
							['ok', response_body]
						elsif interpretation == 'payment_failed'
							['error', 1, interpretation, response_body]
						end
					end
				end  	
			rescue Stripe::InvalidRequestError => e
				['error', 0, e.message]    
			end
			
			def interpret_statuses(statuses)
				subscription_status = statuses.first
				payment_intent_status = statuses.second
				
				if subscription_status == 'active' && payment_intent_status == 'succeeded'
					'success'
				elsif subscription_status == 'incomplete' && payment_intent_status == 'requires_payment_method'
					'payment_failed'
				elsif subscription_status == 'incomplete' && payment_intent_status == 'requires_action'
					'payment_requires_customer_action'
				end
			end

			def get_customer_form_stripe
				response = Stripe::Customer.retrieve(@customer_id)

				['ok', response]
			rescue => e
				['error', e.message]
			end

			def get_subscriptions_from_stripe
				output = get_customer_form_stripe

				if output.first == 'ok'
					customer_body = output.second

					subscriptions = customer_body['subscriptions']
					
					if subscriptions != nil
						['ok', subscriptions]
					end
				else
					['error', output.second]
				end
			end

			def get_subscription_id_from_stripe
				output = get_subscriptions_from_stripe

				if output.first == 'ok'
					subscriptions = output.second

					if subscriptions['total_count'] == 1
						if subscriptions['data'] != nil
							subscription = subscriptions['data'].first

							if subscription != nil
								['ok', subscription['id'], subscription, subscription.items.data[0].id]
							end
						end
					else
						['error', 1]
					end
				else
					['error', 0, output.second]
				end
			end

			def cancel_subscription_in_stripe
				response = Stripe::Subscription.delete(@subscription_id)

				['ok', response]
			rescue => e
				['error', e.message]
			end

			def update_subscription_in_stripe
				response = Stripe::Subscription.update(@subscription_id,
								{cancel_at_period_end: false, items: [{ id: @sub_item_id,
																		plan: @plan_id}]})

				['ok', response]
			rescue => e
				['error', e.message]
			end
	end

end

