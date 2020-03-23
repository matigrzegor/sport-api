module Api::V1

    class QueueInvitationsController < ApplicationController
		include Secured
		include AthleteRoled
		include Api::V1::QueueInvitationErrorer
		include Api::V1::InvitationSerializer
        before_action :management_token, only: :create

        def create 
			invitation_process = InvitationProcess.new(@management_token, @extracted_user.auth_sub)

			if invitation_process.prepared_to_process == true
				@outputs = invitation_process.perform_invitations_from_pendings
				
				if @outputs.first > 0
					invitations_data = []
					
					@outputs.second.each do |output|
						if output.first == 'ok'
							output.last.destroy
							
							trainer_auth_body = output.third

							invitation = output.second
							invitation.save!
							
							invitation_data = {invitation: invitation, trainer_auth_body: trainer_auth_body}
							
							invitations_data << invitation_data
						end
					end
					
					render json: serialize_full_invitations(invitations_data), status: 200
				else
					render json: {message: "No queue invitation processes to perform."}, status: 200
				end
			else
				render json: auth0_error_one, status: 500
			end
        end


        private

            def management_token
                management_array = ManagementToken.new.get_token
                if management_array.first == 'token'
                    @management_token = management_array.second
                elsif management_array.first == 'error'
                    render json: auth0_management_token_error, status: 500
                end
            end

    end

end

# Controller for role: athlete.
