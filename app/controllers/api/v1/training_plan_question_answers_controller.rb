module Api::V1
    
    class TrainingPlanQuestionAnswersController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::QuestionAnswerSerializer
        before_action :current_training_plan, only: :index

        def index
            question_answers = @current_training_plan.question_answers.all

            render json: serialize_question_answers(question_answers), status: :ok
        end

        private

            def current_training_plan
                @current_training_plan = @extracted_user.training_plans.find(params[:training_plan_id])
            end

    end

end

# Controller for role: trainer.
# --------------------------------------------------------------------
# With this controller, trainer fetch his athlete's answers.