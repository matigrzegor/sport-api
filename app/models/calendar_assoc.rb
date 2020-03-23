class CalendarAssoc < ApplicationRecord
    belongs_to :tile
    belongs_to :training_plan

    # question_answer_metadata associations
    has_many :question_answer_metadata, dependent: :destroy

    # presence validations
    validates :calendar_date, :tile_color, :asso_index_in_array, presence: true

    # length validations
    validates :calendar_date, :tile_color, length: {maximum: 255}
    
    # custom validation
    validate :validate_whether_plan_and_tile_belong_to_the_same_user

    private
    
        def validate_whether_plan_and_tile_belong_to_the_same_user
            if self.tile != nil && self.training_plan != nil
                if self.tile.user != nil && self.training_plan.user != nil
                    if self.tile.user != self.training_plan.user
                        errors.add(:base, "Training plan and tile must belong to the same user")
                    end
                end
            end
        end
end
