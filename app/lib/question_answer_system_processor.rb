class QuestionAnswerSystemProcessor

    def create_metadatum(calendar_assoc)
        if calendar_assoc.tile.tile_type == "question"
            data_hash = {
                tile_id: calendar_assoc.tile_id,
                training_plan_id: calendar_assoc.training_plan_id,
                training_sesion: calendar_assoc.training_sesion,
                calendar_date: calendar_assoc.calendar_date
            }
            
            if calendar_assoc.question_answer_metadata.count == 0
                calendar_assoc.question_answer_metadata.create!(data_hash)
            end

            {status: :ok}
        else
            {status: :ok}
        end
    end

    def create_metadata(calendar_assocs)
        calendar_assocs.each do |calendar_assoc|
            create_metadatum(calendar_assoc)
        end

        {status: :ok}
    end

    def update_asso_index_in_metadatum(calendar_assoc)
        question_answer_metadata = calendar_assoc.question_answer_metadata

        if question_answer_metadata.count == 1
        
            question_answer_metadatum = question_answer_metadata.first

            question_answer_metadatum.training_sesion = calendar_assoc.training_sesion
            question_answer_metadatum.save!
        end

        {status: :ok}
    end

    def update_question_answered_in_metadatum(calendar_assoc)
        question_answer_metadata = calendar_assoc.question_answer_metadata

        if question_answer_metadata.count == 1
        
            question_answer_metadatum = question_answer_metadata.first

            question_answer_metadatum.question_answered = true
            question_answer_metadatum.save!
        end

        {status: :ok}
    end

    def update_question_answered_in_metadata(calendar_assocs)
        calendar_assocs.each do |calendar_assoc|
            update_question_answered_in_metadatum(calendar_assoc)
        end
    end

end

