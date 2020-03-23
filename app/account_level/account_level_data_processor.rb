module AccountLevel

    class AccountLevelDataProcessor

        def initialize(management_token, user_id, user_body = {})
			@management_token = management_token
            @user_id = user_id
            @user_body = user_body
            @extracted_user = User.find_by(auth_sub: @user_id)
		end
		
		def create_trial
            trial_dates_hash = AccountLevel::ProcessorHelper.new.generate_trial_dates
            account_level_hash = {account_level: AccountLevel::ACCOUNTLEVELS['trial_account']}

            @account_level_data_hash = trial_dates_hash.merge(account_level_hash)
            
            account_level_data_hash_for_user_update = @account_level_data_hash 
            @extracted_user.update!(account_level_data_hash_for_user_update)

			output = update_app_metadata
			
			if output.first == 'ok'
				['ok', @account_level_data_hash]
			else
				['error', output.second]
			end
        end

        def end_trial(account_level_data)
            old_account_level_data_hash = account_level_data
            
            account_level_hash = {account_level: AccountLevel::ACCOUNTLEVELS['athlete_account']}

            @account_level_data_hash = old_account_level_data_hash.merge(account_level_hash)

            account_level_data_hash_for_user_update = @account_level_data_hash
            @extracted_user.update!(account_level_data_hash_for_user_update)

            output = update_app_metadata
			
			if output.first == 'ok'
				['ok', @account_level_data_hash]
			else
				['error', output.second]
			end
        end

        def cancel_subscription(operation_type)
            if operation_type == :cancel_from_user
                @output_first = get_old_account_level_data_through_trial_processor(:with_user_body)
            elsif operation_type == :cancel_from_event
                @output_first = get_old_account_level_data_through_trial_processor(:without_user_body)
            end

            if @output_first.first == 'ok'
                old_account_level_data_hash = @output_first.second
                
                if old_account_level_data_hash['current_paid_access_end_date'] != nil
                    validated_trial_dates_hash = AccountLevel::ProcessorHelper.new
                                                .return_validated_trial_dates(:downgrade, old_account_level_data_hash)

                    expiration_status = AccountLevel::ProcessorHelper.new
                                        .return_date_expiration_status(validated_trial_dates_hash[:trial_end_date])
                        
                    if expiration_status == 'expired'
                        @account_level_hash = {account_level: AccountLevel::ACCOUNTLEVELS['athlete_account']}
                    elsif expiration_status == 'not_expired'
                        @account_level_hash = {account_level: AccountLevel::ACCOUNTLEVELS['trial_account']}
                    end              

                    if validated_trial_dates_hash != nil
                        @account_level_data_hash = old_account_level_data_hash.slice('stripe_customer_id')
                                                    .merge(@account_level_hash).merge(validated_trial_dates_hash)
                    end

                    account_level_data_hash_for_user_update = @account_level_data_hash
                                                            .merge({current_paid_access_start_date: nil,
                                                                   current_paid_access_end_date: nil})
                    @extracted_user.update!(account_level_data_hash_for_user_update)

                    output_second = update_app_metadata
                
                    AccountLevel::Downgrade.new(@management_token, @extracted_user).perform_downgrade

                    if output_second.first == 'ok'
                        ['ok', @account_level_data_hash]
                    else
                        ['error', 2, output_second.second]
                    end
                else
                    ['ok', old_account_level_data_hash]
                end
            elsif @output_first.first == 'error' && @output_first.second == 0
                ['error', 0, @output_first.last]
            elsif @output_first.first == 'error' && @output_first.second == 1
                ['error', 1]
            end
        end

        def create_subscription(operation_type, subscription_data, plan_id, customer_id = '')
            if operation_type == :initial_create || operation_type == :following_create
                @output_first = get_old_account_level_data_through_trial_processor(:with_user_body)
            elsif operation_type == :event_sustain
                @output_first = get_old_account_level_data_through_trial_processor(:without_user_body)
            end

            if @output_first.first == 'ok'
                old_account_level_data_hash = @output_first.second

                processor_helper = AccountLevel::ProcessorHelper.new

                account_level = AccountLevel::ACCOUNTLEVELS[plan_id]
                
                if old_account_level_data_hash['stripe_customer_id'] != nil
                    @stripe_customer_id = old_account_level_data_hash['stripe_customer_id']
                else
                    @stripe_customer_id = customer_id
                end

                if operation_type == :initial_create || operation_type == :following_create
                    @current_paid_access_start_date = subscription_data['current_period_start']
                    @current_paid_access_end_date = processor_helper.return_leewayed_end_date(subscription_data['current_period_end'])
                elsif operation_type == :event_sustain
                    @current_paid_access_start_date = subscription_data['start']
                    @current_paid_access_end_date = processor_helper.return_leewayed_end_date(subscription_data['end'])
                end

                validated_trial_dates_hash = processor_helper.return_validated_trial_dates(:upgrade,
                                                        old_account_level_data_hash, @current_paid_access_start_date,
                                                        @current_paid_access_end_date)
                
                if validated_trial_dates_hash != nil
                    @account_level_data_hash = {
                        account_level: account_level,
                        'stripe_customer_id' => @stripe_customer_id,
                        current_paid_access_start_date: @current_paid_access_start_date,
                        current_paid_access_end_date: @current_paid_access_end_date
                    }.merge(validated_trial_dates_hash)
                end
                
                if operation_type == :initial_create
                    @account_level_data_hash_for_user_update = @account_level_data_hash
                                                        .merge({paid_access_start_date: @current_paid_access_start_date})
                else
                    @account_level_data_hash_for_user_update = @account_level_data_hash
                end

                @extracted_user.update!(@account_level_data_hash_for_user_update)

                output = update_app_metadata

                if output.first == 'ok'
                    ['ok', @account_level_data_hash]
                else
                    ['error', 2, output.second]
                end
            elsif @output_first.first == 'error' && @output_first.second == 0
                ['error', 0, @output_first.last]
            elsif @output_first.first == 'error' && @output_first.second == 1
                ['error', 1]
            end
        end

        def update_subscription(plan_id)
            output_first = get_old_account_level_data_through_trial_processor(:with_user_body)

            if output_first.first == 'ok'
                old_account_level_data_hash = output_first.second

                account_level_hash = {account_level: AccountLevel::ACCOUNTLEVELS[plan_id]}
                
                if old_account_level_data_hash != nil
                    @account_level_data_hash = old_account_level_data_hash.merge(account_level_hash)
                end

                account_level_data_hash_for_user_update = @account_level_data_hash
                @extracted_user.update!(account_level_data_hash_for_user_update)

                output = update_app_metadata

                AccountLevel::Downgrade.new(@management_token, @extracted_user).perform_downgrade

                if output.first == 'ok'
                    ['ok', @account_level_data_hash]
                else
                    ['error', 2]
                end
            
            elsif output_first.first == 'error' && output_first.second == 0
                ['error', 0]
            elsif output_first.first == 'error' && output_first.second == 1
                ['error', 1]
            end
        end
        
        private

            def update_app_metadata
                output = HTTP.auth("Bearer #{@management_token}")
                            .patch("#{ENV['AUTHO_DOMAIN']}/api/v2/users/#{@user_id}",
                                    json: { app_metadata: { account_level_data: @account_level_data_hash}})
                
                if output.code == 200
                    ['ok']
                else
                    ['error', output.parse]
                end       			
            end
 
            def get_old_account_level_data_through_trial_processor(user_body_status)
                trial_processor = AccountLevel::TrialProcessor.new(user_body_status, @management_token,
                                                               @user_id, @user_body)
			
                if trial_processor.prepared_to_process == true
                    if trial_processor.trial_updation_permited?
                        old_account_level_data = trial_processor.account_level_data
                        
                        if old_account_level_data != nil
                            ['ok', old_account_level_data]
                        end

                    elsif trial_processor.trial_creation_permited?
                        ['error', 1]
                    end
                else
                    ['error', 0, trial_processor.error_message]
                end
            end

            #def return_update_type(old_account_level_data_hash, new_account_level_data_hash)
            #    old_account_level = old_account_level_data_hash['account_level']
            #    new_account_level = new_account_level_data_hash['account_level']
            #
            #    if old_account_level != nil && new_account_level != nil
            #        if old_account_level > new_account_level
            #           :downgrade
            #        elsif old_account_level <= new_account_level
            #            :upgrade
            #        end
            #    end
            #end

    end
end

# account_level_data: {
#   account_level: 1/2/3/...,
#   trial_start_date: '',
#   trial_end_date: ''
# }
