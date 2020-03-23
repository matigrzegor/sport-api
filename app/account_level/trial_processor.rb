module AccountLevel
	
	class TrialProcessor
		attr_reader :prepared_to_process, :error_message,
					:account_level_data
		
		def initialize(user_body_status, management_token, user_id, user_body = {})
			@user_body_status = user_body_status
			@user_body = user_body
			@management_token = management_token
			@user_id = user_id
			output = return_trial_status
			if output.first == 'ok'
				@prepared_to_process = true
				@trial_status = output.second
			elsif output.first == 'error'
				@prepared_to_process = false
				@error_message = output.second
			end
		end
		
		def trial_creation_permited?
			if @trial_status == 'to_create'
				true
			elsif @trial_status == 'to_update'
				false
			end
		end
		
		def trial_updation_permited?
			if @trial_status == 'to_update'
				true
			elsif @trial_status == 'to_create'
				false
			end
		end

		def create_trial
			if trial_creation_permited?
				output = AccountLevel::AccountLevelDataProcessor
							.new(@management_token, @user_id).create_trial
				
				if output.first == 'ok'
					['ok', output.second]
				else
					['error', 1, output.second]
				end
				
			else
				['error', 0]
			end
		end

		def end_trial
			if trial_updation_permited?
				expiration_status = AccountLevel::ProcessorHelper.new
										.return_date_expiration_status(@account_level_data['trial_end_date'])
		
				if expiration_status == 'expired'
					output = AccountLevel::AccountLevelDataProcessor
								.new(@management_token, @user_id).end_trial(@account_level_data)

					if output.first == 'ok'
						['ok', output.second]
					else
						['error', 1, output.second]
					end
				elsif expiration_status == 'not_expired'
					['error', 0]
				elsif @account_level_data['current_paid_access_start_date'] != nil
					['error', 0]
				end
			else
				['error', 0]
			end
		end
		
		private
			
			def return_trial_status
				output = get_account_level_data_status
				
				if output.first == 'ok'
					output_array = ['ok']
					
					if output.second == 'no_account_level_data'
						output_array << 'to_create'
					elsif output.second == 'presence_of_trial_data'
						output_array << 'to_update'
						@account_level_data = output.last
					end

					output_array
				else
					['error', output.second]
				end
			
			end
			
			def get_account_level_data_status
				if @user_body_status == :with_user_body
					return_account_level_data_status_array(@user_body)
				elsif @user_body_status == :without_user_body
					output = AuthZeroHelper.new(@management_token).get_user_from_auth(@user_id)
					
					if output.first == 'ok'
						user_body = output.second
						
						return_account_level_data_status_array(user_body)
					else
						['error', output.second]
					end
				end
			end

			def return_account_level_data_status_array(user_body)
				output_array = ['ok']
					
				if user_body['app_metadata'] != nil
					account_level_data = user_body['app_metadata']['account_level_data']
					
					if account_level_data != nil
						output_array << 'presence_of_trial_data' << account_level_data
					else
						output_array << 'no_account_level_data'
					end
				
				else
					output_array << 'no_account_level_data'
				end
				
				output_array
			end
			
	end

end