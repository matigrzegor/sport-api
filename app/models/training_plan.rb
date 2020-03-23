class TrainingPlan < ApplicationRecord
    # user association
    belongs_to :user

    # board_notes associations
    has_many :board_notes, as: :boardable, dependent: :destroy

    # calendar (has_many_through)
    has_many :calendar_assocs
    has_many :tiles, through: :calendar_assocs, dependent: :destroy

    # question_answers associations
    has_many :question_answers, dependent: :destroy

    # platform associations
    has_many :plan_appends
    has_many :athlete_platforms, through: :plan_appends, dependent: :destroy

    # calendar_stars associations
    has_many :calendar_stars, dependent: :destroy

    # calendar_stars associations
    has_many :calendar_comments, dependent: :destroy

    # question_answer_metadata associations
    has_many :question_answer_metadata, dependent: :destroy
    
    # presence validations
    validates :training_plan_name, :date_from, :date_to, presence: true

    # length validations
    validates :training_plan_name, :date_from, :date_to, length: {maximum: 255}
end
