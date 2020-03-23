class EmailProcessor

	def initialize(recipient_email)
		@recipient_email = recipient_email
	end

	def to_app_invitation_email(trainer_email, trainer_nick)
		ToAppInvitationMailer.with(athlete_email: @recipient_email,
								   trainer_email: trainer_email,
								   trainer_nick: trainer_nick)
								   .to_app_invitation_email.deliver_now
	end
	
	def in_app_feedback_email(email, description)
		InAppFeedbackMailer.with(recipient_email: @recipient_email,
								 user_email: email,
								 description: description)
								 .in_app_feedback_email.deliver_now
	end

end