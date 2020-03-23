module Api::V1
    
    class PlatformTrainingPlanQuestionAnswersController < ApplicationController
        include Secured
        include AthleteRoled
        include Athleted
        include Api::V1::QuestionAnswerSerializer

        def create
            question_answers = @plan_append.training_plan.question_answers.create!(question_answers_params)

            QuestionAnswerSystemProcessor.new.update_question_answered_in_metadata(calendar_assocs_from_params)

            render json: serialize_question_answers(question_answers), status: :ok
        end

        private

            def question_answers_params
                permitted_params = params.permit({question_answers: [:tile_id, :question_date,
                                                                     :question_answer, :answer_comment]})

                validated_params = []

                permitted_params[:question_answers].each do |question_answer|
                    tile = @plan_append.training_plan.user.tiles.find(question_answer[:tile_id])
                    
                    if tile != nil
                        validated_params << question_answer
                    end
                end

                validated_params
            end

            def calendar_assocs_from_params
                calendar_assoc_ids = params.permit(calendar_assoc_id: [])[:calendar_assoc_id]

                calendar_assocs = []

                if calendar_assoc_ids != nil
                    calendar_assoc_ids.each do |calendar_assoc_id|
                        calendar_assocs << @plan_append.training_plan.calendar_assocs.find(calendar_assoc_id)
                    end
                end

                calendar_assocs
            end
    end

end

# Controller for role: athlete.