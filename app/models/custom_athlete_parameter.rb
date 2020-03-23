class CustomAthleteParameter < ApplicationRecord
    belongs_to :athlete_platform

    # presence validations
    validates :parameter_name, :parameter_date, :parameter_description, presence: true

    # length validations
    validates :parameter_name, :parameter_date, length: {maximum: 255}
    validates :parameter_description, length: {maximum: 255}
end
