module AccountLevel

	class ProcessorHelper
	
		def generate_trial_dates(days = 14)
			trial_start_date = Time.new.to_i
			trial_end_date = (trial_start_date + (3600 * 24 * days)).to_i
			
			{trial_start_date: trial_start_date,
			 trial_end_date: trial_end_date}
		end
	
		def return_validated_trial_dates(update_type, old_account_level_data, 
										 current_paid_access_start_date = 0, current_paid_access_end_date = 0)
			
			if update_type == :upgrade
				seconds = current_paid_access_end_date - current_paid_access_start_date
				
				old_trial_start_date = old_account_level_data['trial_start_date']
				old_trial_end_date = old_account_level_data['trial_end_date']
				
				if old_trial_end_date != nil && old_trial_start_date != nil
					time_difference = old_trial_end_date - current_paid_access_start_date
					fourteen_days = 3600 * 24 * 14

					if time_difference < fourteen_days && old_trial_end_date > Time.new.to_i
						new_trial_end_date = old_trial_end_date + seconds
						
						{trial_start_date: old_trial_start_date,
							trial_end_date: new_trial_end_date}
					else
						{trial_start_date: old_trial_start_date,
							trial_end_date: old_trial_end_date}
					end
				end
			elsif update_type == :downgrade
				old_trial_end_date = old_account_level_data['trial_end_date']
				old_trial_start_date = old_account_level_data['trial_start_date']
				old_current_paid_access_end_date = old_account_level_data['current_paid_access_end_date']
				old_current_paid_access_start_date = old_account_level_data['current_paid_access_start_date']
			
				if old_current_paid_access_end_date != nil && old_current_paid_access_start_date != nil && old_trial_end_date != nil && old_trial_start_date != nil
					
					if old_trial_end_date > old_current_paid_access_end_date
						seconds = old_current_paid_access_end_date - Time.new.to_i

						new_trial_end_date = old_trial_end_date - seconds
						new_trial_start_date = old_trial_start_date

						{trial_start_date: new_trial_start_date,
						 trial_end_date: new_trial_end_date}
					else
						{trial_start_date: old_trial_start_date,
						 trial_end_date: old_trial_end_date}
					end
				end
			end
		end

		def return_date_expiration_status(end_date)
			if end_date != nil
				if end_date < Time.new.to_i
					'expired'
				else
					'not_expired'
				end
			end
		end

		def return_leewayed_end_date(end_date)
			if end_date != nil
				leeway_days_number = 2
				
				end_date + (3600 * 24 * leeway_days_number)
			end
		end

		def compare_end_dates(leeway_status, old_end_date, new_end_date)
			if leeway_status == :with_leeway
				leewayed_new_end_date = return_leewayed_end_date(new_end_date)
				
				if old_end_date != nil && leewayed_new_end_date != nil
					if old_end_date == leewayed_new_end_date
						'the same'
					else
						'not the same'
					end
				end
			end
		end

		def return_account_level_data_from_database(extracted_user, key_type)
			if key_type == :string
				{
					'account_level' => extracted_user.account_level,
					'stripe_customer_id' => extracted_user.stripe_customer_id,
					'current_paid_access_start_date' => extracted_user.current_paid_access_start_date,
					'current_paid_access_end_date' => extracted_user.current_paid_access_end_date,
					'trial_start_date' => extracted_user.trial_start_date,
					'trial_end_date' => extracted_user.trial_end_date
				}
			elsif key_type == :symbol
				{
					account_level: extracted_user.account_level,
					stripe_customer_id: extracted_user.stripe_customer_id,
					current_paid_access_start_date: extracted_user.current_paid_access_start_date,
					current_paid_access_end_date: extracted_user.current_paid_access_end_date,
					trial_start_date: extracted_user.trial_start_date,
					trial_end_date: extracted_user.trial_end_date
				}
			end	
		end

	end

end