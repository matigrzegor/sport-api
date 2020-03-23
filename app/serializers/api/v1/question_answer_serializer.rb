module Api::V1

    module QuestionAnswerSerializer

        def serialize_question_answer(question_answer)
            {
                id: question_answer.id,
                tile_id: question_answer.tile_id,
                question_date: question_answer.question_date,
                question_answer: question_answer.question_answer,
                answer_comment: question_answer.answer_comment
            }
        end
        
        def serialize_question_answers(question_answers)
            question_answers.map do |question_answer|
                serialize_question_answer(question_answer)
            end
        end

    end

end