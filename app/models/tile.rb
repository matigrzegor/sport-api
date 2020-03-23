class Tile < ApplicationRecord
    belongs_to :user
    
    has_many :tile_activities, dependent: :destroy
    has_many :tile_diets, dependent: :destroy
    has_one :tile_question, dependent: :destroy
    has_one :tile_motivation, dependent: :destroy

    # tags
    has_many :taggings
    has_many :tags, through: :taggings, dependent: :destroy

    accepts_nested_attributes_for :tile_activities, :tile_question, :tile_motivation, :tile_diets, allow_destroy: true

    # calendar (has_many_through)
    has_many :calendar_assocs
    has_many :training_plans, through: :calendar_assocs, dependent: :destroy

    # question answers
    has_many :question_answers, dependent: :destroy

    # presence validations
    validates :tile_type, :tile_title, :tile_type_name, :tile_type_color, presence: true

    # length validations
    validates :tile_type, :tile_title, :tile_type_name, :tile_type_color, :tile_activities_sets_rest_amount,
                :tile_activities_sets_rest_intensity_amount, length: {maximum: 255}
    validates :tile_description, length: {maximum: 30000}

end
