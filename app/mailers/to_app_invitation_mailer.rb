class ToAppInvitationMailer < ApplicationMailer
    default from: 'matigrzegor@gmail.com'
 
    def to_app_invitation_email
        @athlete_email = params[:athlete_email]
        @trainer_email = params[:trainer_email]
        @trainer_nick = params[:trainer_nick]
        @sport_app_sign_up_url = ENV['SPORT_APP_SIGN_UP_URL']

        mail(to: @athlete_email, subject: 'Welcome to Sport app')
    end
end
