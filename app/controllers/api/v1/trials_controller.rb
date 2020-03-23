module Api::V1

    class TrialsController < ApplicationController
		include Secured
        before_action :error_creator, only: [:create_trial, :end_trial]
        before_action :management_token, only: [:create_trial, :end_trial]
        
		def create_trial
			trial_processor = AccountLevel::TrialProcessor.new(:without_user_body,
											 @management_token, @extracted_user.auth_sub)
			
			if trial_processor.prepared_to_process == true
				output = trial_processor.create_trial
				
				if output.first == 'ok'
					render json: {account_level_data: output.second}, status: 200
				elsif output.first == 'error' && output.second == 0
					render json: @error_creator.create_error(404, 1), status: 404
				elsif output.first == 'error' && output.second == 1
					render json: @error_creator.create_error(500, 2), status: 500
				end
			else
				render json: @error_creator.create_error(500, 3), status: 500
			end
		end

		def end_trial
			trial_processor = AccountLevel::TrialProcessor.new(:without_user_body,
											 @management_token, @extracted_user.auth_sub)
			
			if trial_processor.prepared_to_process == true
				output = trial_processor.end_trial
				
				if output.first == 'ok'
					AccountLevel::Downgrade.new(@management_token, @extracted_user, output.second[:account_level])

					render json: {account_level_data: output.second}, status: 200
				elsif output.first == 'error' && output.second == 0
					render json: @error_creator.create_error(404, 4), status: 404
				elsif output.first == 'error' && output.second == 1
					render json: @error_creator.create_error(500, 5), status: 500
				end
			else
				render json: @error_creator.create_error(500, 6), status: 500
			end
		end
    
        private
    
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

# Controller for a user without any role.