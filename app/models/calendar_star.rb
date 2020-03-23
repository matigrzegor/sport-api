class CalendarStar < ApplicationRecord
    # training_plan association
    belongs_to :training_plan

    # presence validations
    validates :star_color, :star_date, presence: true

    # length validations
    validates :star_color, :star_date, length: {maximum: 255}
    validates :star_description, length: {maximum: 30000}
end
