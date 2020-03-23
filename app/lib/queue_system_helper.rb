class QueueSystemHelper

	def generate_expiration_date(days = 7)
		time = Time.new + (3600 * 24 * days)
		time.to_i
	end

	def return_expired_invitations(pending_user_invitations)
		expired_invitations = []
		
		pending_user_invitations.each do |invitation|
			if Time.new.to_i > invitation.expiration_date
				expired_invitations << invitation
			end
		end
		
		expired_invitations
	end

	def clean_queue(pending_user_invitations)
		pending_user_invitation = pending_user_invitations.first
		removed_user_identifier = pending_user_invitation.user_identifier
		pending_user_invitation.destroy

		removed_user_identifier
	end

end
