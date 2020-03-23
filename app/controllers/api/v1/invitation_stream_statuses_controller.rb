module Api::V1

    class InvitationStreamStatusesController < ApplicationController
		include Secured
		#include AthleteRoled

        def show
			memberships = @extracted_user.memberships.where(membership_status: 'attendant')
            
            if memberships.count == 1
                render json: {permitted: false}, status: 200
            elsif memberships.count == 0
                render json: {permitted: true}, status: 200
            end
        end

    end

end