class CalendarComment < ApplicationRecord
    # training_plan association
    belongs_to :training_plan

    # presence validations
    validates :comment_user, :comment_data, :comment_day, :comment_user_role,  presence: true

    # length validations
    validates :comment_user, :comment_data, :comment_day, :comment_user_role, length: {maximum: 255}
    validates :comment_body, length: {maximum: 30000}
end
