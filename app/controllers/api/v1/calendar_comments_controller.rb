module Api::V1

    class CalendarCommentsController < ApplicationController
        include Secured
        include TrainerRoled
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
                    comment_user_role: 'trainer',
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
                @current_training_plan = @extracted_user.training_plans.find(params[:training_plan_id])
            end

            def current_calendar_comment
                current_calendar_comment = @current_training_plan.calendar_comments.find(params[:id])

                if current_calendar_comment.comment_user_role == 'trainer'
                    @current_calendar_comment = current_calendar_comment
                else
                    render json: @error_creator.create_error(400, 1)
                end
            end

            def error_creator
                @error_creator = Errorer::ErrorCreator.new(:calendar_comments)
            end
    end

end

# Controller for role: trainer.