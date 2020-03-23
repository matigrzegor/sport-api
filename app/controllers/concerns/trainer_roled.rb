module TrainerRoled
	extend ActiveSupport::Concern
    
    included do
        before_action :check_user_role
    end

	private

		def check_user_role
			role = @account_checker.account_possibilities[:role]
			if role != 'trainer'
				render json: Errorer::ErrorCreator.new(:trainer_roled).create_error(403, 1), status: 403
			end
		end

end