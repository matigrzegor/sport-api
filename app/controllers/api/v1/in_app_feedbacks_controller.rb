module Api::V1

    class InAppFeedbacksController < ApplicationController
        include Secured
        include AthleteRoled
        
        def create
            EmailProcessor.new('gremmomateusz@gmail.com').in_app_feedback_email(*in_app_feedback_params)

            render json: {message: "Email sent"}, status: 200
        end

        private

            def in_app_feedback_params
                permitted_params = params.permit(:email, :description)

                email = permitted_params[:email]
                description = permitted_params[:description]

                [email, description]
            end
            
    end

end

# Controller for role: athlete.