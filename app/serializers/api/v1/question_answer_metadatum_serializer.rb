module Api::V1

    module QuestionAnswerMetadatumSerializer

        def serialize_question_answer_metadatum(question_answer_metadatum)
            {
                id: question_answer_metadatum.id,
                training_sesion: question_answer_metadatum.training_sesion,
                calendar_date: question_answer_metadatum.calendar_date,
                tile_id: question_answer_metadatum.tile_id,
                calendar_assoc_id: question_answer_metadatum.calendar_assoc_id,
                training_plan_id: question_answer_metadatum.training_plan_id
            }
        end
        
        def serialize_question_answer_metadata(question_answer_metadata)
            question_answer_metadata.map do |question_answer_metadatum|
                serialize_question_answer_metadatum(question_answer_metadatum)
            end
        end

    end

end