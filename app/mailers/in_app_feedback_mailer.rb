class InAppFeedbackMailer < ApplicationMailer
    default from: 'matigrzegor@gmail.com'
 
    def in_app_feedback_email
        @recipient_email = params[:recipient_email]
        @user_email = params[:user_email]
        @description = params[:description]

        mail(to: @recipient_email, subject: ' Sport app | In app feedback')
    end
end