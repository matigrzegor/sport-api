class QuestionAnswer < ApplicationRecord
    belongs_to :training_plan
    belongs_to :tile

    # presence validations
    validates :question_date, presence: true

    # length validations
    validates :question_date, :question_answer, length: {maximum: 255}
    validates :answer_comment, length: {maximum: 30000}
end
