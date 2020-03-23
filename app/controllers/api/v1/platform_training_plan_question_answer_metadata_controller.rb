module Api::V1

    class PlatformTrainingPlanQuestionAnswerMetadataController < ApplicationController
        include Secured
        include AthleteRoled
        include Athleted
        include Api::V1::QuestionAnswerMetadatumSerializer

        def index
            question_answer_metadata = @plan_append.training_plan.question_answer_metadata.where(question_answered: false)

            render json: serialize_question_answer_metadata(question_answer_metadata), status: :ok
        end

    end

end

# Controller for role: athlete.
