module Api::V1

    class CalendarStarsController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::CalendarStarSerializer
        before_action :current_training_plan, only: [:create, :destroy, :update]
        before_action :current_calendar_star, only: [:destroy, :update]

        def create
            calendar_star = @current_training_plan.calendar_stars.create!(calendar_star_params)

            render json: serialize_calendar_star(calendar_star), status: :ok
        end

        def destroy
            @current_calendar_star.destroy

            render json: {message: "Calendar star was successfully deleted"}, status: :ok
        end

        def update
            @current_calendar_star.update!(calendar_star_params)

            render json: serialize_calendar_star(@current_calendar_star), status: :ok
        end

        private     
            
            def calendar_star_params
                params.permit(:star_color, :star_description, :star_date)
            end

            def current_training_plan
                @current_training_plan = @extracted_user.training_plans.find(params[:training_plan_id])
            end

            def current_calendar_star
                @current_calendar_star = @current_training_plan.calendar_stars.find(params[:id])
            end
    end

end

# Controller for role: trainer.