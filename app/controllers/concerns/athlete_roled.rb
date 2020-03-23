module AthleteRoled
	extend ActiveSupport::Concern
    
    included do
        before_action :check_user_role
    end

	private

		def check_user_role
			role = @account_checker.account_possibilities[:role]	
			if !(role == 'trainer' || role == 'athlete')
				render json: Errorer::ErrorCreator.new(:athlete_roled).create_error(403, 1), status: 403
			end
		end
end