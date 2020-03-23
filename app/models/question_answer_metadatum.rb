class QuestionAnswerMetadatum < ApplicationRecord
    belongs_to :calendar_assoc
    belongs_to :training_plan

    # presence validations
    validates :training_sesion, :calendar_date, :tile_id, presence: true

    # length validations
    validates :calendar_date, length: {maximum: 255}

    # custom validations
    validate :validate_number_of_matadata_on_calendar_assoc
    
    private
    
        def validate_number_of_matadata_on_calendar_assoc
            if self.new_record? && self.calendar_assoc != nil
                if self.calendar_assoc.question_answer_metadata.count >= 1
                    errors.add(:base, "Platform can have only two memberships")
                end
            end
        end
end
