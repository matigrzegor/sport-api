module AccountLevel

	class Checker
		attr_reader :user_permitted, :account_possibilities, :action_to_be_performed

		def initialize(extracted_user)
			@extracted_user = extracted_user
			return_account_possibilities
		end

		def return_account_possibilities
			processor_helper = AccountLevel::ProcessorHelper.new
			
			account_level = @extracted_user.account_level
			current_paid_access_end_date = @extracted_user.current_paid_access_end_date
			trial_end_date = @extracted_user.trial_end_date
			
			has_paid_dates = true if current_paid_access_end_date != nil
			has_paid_dates = false if current_paid_access_end_date == nil

			if trial_end_date == nil
				@user_permitted = true
				@account_possibilities = AccountLevel::POSSIBILITIES[:initial]
			elsif trial_end_date != nil
				if account_level == 0
					@proceding_permited = true
				elsif account_level > 0 && account_level <= 12 && has_paid_dates == true
					expiration_status = processor_helper.return_date_expiration_status(current_paid_access_end_date)

					if expiration_status == 'not_expired'
						@proceding_permited = true
					else
						@proceding_permited = false
						@action_to_be_performed = :paid_account_downgrade
					end
				elsif account_level == 1 && has_paid_dates == false
					expiration_status = processor_helper.return_date_expiration_status(trial_end_date)

					if expiration_status == 'not_expired'
						@proceding_permited = true
					else
						@proceding_permited = false
						@action_to_be_performed = :trial_account_downgrade
					end
				else
					@proceding_permited = false
				end

				if @proceding_permited == true
					@user_permitted = true
					@account_possibilities = AccountLevel::POSSIBILITIES[account_level]
				elsif @proceding_permited == false
					@user_permitted = false
				end
			end
		end

		def permitted_to_make_athlete_platform?
			check_access_to_make_athlete_platforms
		end

		def permitted_to_make_training_plan?
			check_access_to_make_training_plans
		end

		def permitted_to_make_platform_invite?
			check_access_to_make_platform_invites
		end

		def return_limited_resources(resources_type, resources)
			fetch_number = @account_possibilities[resources_type] - 1

			sorted_resources = (resources.sort {|x, y| y[:created_at] <=> x[:created_at]}).reverse

			sorted_resources.values_at(0..fetch_number).compact
		end

		private

			def check_access_to_make_athlete_platforms
				access_number = @account_possibilities[:athlete_platforms]

				utilized_number = @extracted_user.memberships.where(membership_status: 'founder').count

				if access_number > utilized_number
					true
				else
					false
				end
			end

			def check_access_to_make_training_plans
				access_number = @account_possibilities[:training_plans]

				utilized_number = @extracted_user.training_plans.count

				if access_number > utilized_number
					true
				else
					false
				end
			end

			def check_access_to_make_platform_invites
				access_number = @account_possibilities[:platform_invites]
	
				utilized_number = 0
							
				@extracted_user.athlete_platforms.each do |platform|
					if platform.memberships.where(membership_status: 'attendant').count > 0
						utilized_number += 1
					end
	
					if platform.invitations.count > 0
						utilized_number += 1
					end

					if platform.pending_user_invitations.count > 0
						utilized_number += 1
					end
				end
	
				if access_number > utilized_number
					true
				else
					false
				end
			end

	end

end