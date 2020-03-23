class InvitationProcess
	attr_reader :prepared_to_process, :error_message

	def initialize(management_token, athlete_id)
		@management_token = management_token
		@athlete_id = athlete_id
		@response = get_user_from_auth(@athlete_id)
		if @response.first == 'ok'
			@prepared_to_process = true
			@athlete_body = @response.second
		elsif @response.first == 'error'
			@prepared_to_process = false
			@error_message = @response.second
		end
	end
	
	def perform_invitations_from_pendings
		pending_user_invitations = PendingUserInvitation.where(athlete_identifier: @athlete_body['email'])
		
		if pending_user_invitations.any?
			outputs = pending_user_invitations.map do |pending_user_invitation|
				if pending_user_invitation.athlete_platform != nil
					perform_invitation(pending_user_invitation.athlete_platform) << pending_user_invitation
				end
			end
		
			[outputs.size, outputs]
		else
			[0]
		end
	end
	
	def perform_invitation(athlete_platform)
		@trainer_id  = get_trainer_id(athlete_platform)
		
		response = get_user_from_auth(@trainer_id)

		if response.first == 'ok'
			@trainer_email = response.second['email']
			@trainer_nick = response.second['username']
			

			@invitation = athlete_platform.invitations.new(recipient_id: @athlete_id)
			@invitation.generate_platform_token
			

			if @athlete_body['app_metadata'] != nil
				@recipient_invitations = @athlete_body['app_metadata']['invitations']
			else
				@recipient_invitations = nil
			end
	
			response = create_invitation_in_auth
			
			
			if response.code == 200
				@response_status = 'ok'
			else
				@response_status = 'create-invitation-error'
			end
			
			[@response_status, @invitation, response.parse]
		elsif response.first == 'error'
			['get-trainer-error', response.second]
		end
	end

	def destroy_invitation(invitation)
		@invitation = invitation
		
		if @athlete_body['app_metadata'] != nil
	        if @athlete_body['app_metadata']['invitations'] != nil
	            @recipient_invitations = @athlete_body['app_metadata']['invitations']
	                        .select {|invitation| invitation['platform_token'] != @invitation.platform_token }
	        else
	            @recipient_invitations = []
	        end
    	else
            @recipient_invitations = []
        end
        
        response = delete_invitation_in_auth
        
        if response.code == 200
            @response_status = 'ok'
        else
            @response_status = 'error'
        end
        
        [@response_status, @invitation, response.code]
	end
	
	private
        
		def get_trainer_id(athlete_platform)
			memberships = athlete_platform.memberships.where(membership_status: 'founder')

			if memberships.count == 1
				trainer = memberships.first.user
				if trainer != nil
					trainer.auth_sub
				end
			end
		end
	
		def get_user_from_auth(user_id)
            output = AuthZeroHelper.new(@management_token).get_user_from_auth(user_id)
            
            if output.first == 'ok'
            	['ok', output.second]
        	else
            	['error', output.second]
            end
		end
        
        def create_invitation_in_auth
            HTTP.auth("Bearer #{@management_token}")
                .patch("#{ENV['AUTHO_DOMAIN']}/api/v2/users/#{@athlete_id}",
                        json: { app_metadata: { invitations: [*@recipient_invitations, 
                                                                {platform_token: @invitation.platform_token,
																trainer_email: @trainer_email,
																trainer_nick: @trainer_nick }] }})
		end
		
		def delete_invitation_in_auth
            HTTP.auth("Bearer #{@management_token}")
                .patch("#{ENV['AUTHO_DOMAIN']}/api/v2/users/#{@invitation.recipient_id}",
                        json: { app_metadata: { invitations: @recipient_invitations } })
        end
end



