module Api::V1
    
    class PlatformTrainingPlanCalendarCommentsController < ApplicationController
        include Secured
        include AthleteRoled
        include Athleted
        include Api::V1::CalendarCommentSerializer
        before_action :error_creator, only: [:create, :destroy, :update]
        before_action :current_training_plan, only: [:create, :destroy, :update]
        before_action :current_calendar_comment, only: [:destroy, :update]

        def create
            calendar_comment = @current_training_plan.calendar_comments.create!(create_calendar_comment_params)

            render json: serialize_calendar_comment(calendar_comment), status: :ok
        end

        def destroy
            @current_calendar_comment.destroy

            render json: {message: "Calendar comment was successfully deleted"}, status: :ok
        end

        def update
            @current_calendar_comment.update!(update_calendar_comment_params)

            render json: serialize_calendar_comment(@current_calendar_comment), status: :ok
        end

        private     
            
            def create_calendar_comment_params
                {
                    comment_user_role: 'athlete',
                    comment_user: params.dig(:comment_user),
                    comment_data: params.dig(:comment_data),
                    comment_body: params.dig(:comment_body),
                    comment_day: params.dig(:comment_day)
                }
            end

            def update_calendar_comment_params
                {
                    comment_data: params.dig(:comment_data),
                    comment_body: params.dig(:comment_body)
                }
            end

            def current_training_plan
                @current_training_plan = @plan_append.training_plan
            end

            def current_calendar_comment
                current_calendar_comment = @current_training_plan.calendar_comments.find(params[:id])

                if current_calendar_comment.comment_user_role == 'athlete'
                    @current_calendar_comment = current_calendar_comment
                else
                    render json: @error_creator.create_error(400, 1)
                end
            end

            def error_creator
                @error_creator = Errorer::ErrorCreator.new(:platform_training_plan_calendar_comments)
            end
    end

end

# Controller for role: athlete.