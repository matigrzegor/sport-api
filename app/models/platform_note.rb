class PlatformNote < ApplicationRecord
    belongs_to :athlete_platform

    # presence validations
    validates :platform_note_name, presence: true

    # length validations
    validates :platform_note_name, :platform_note_link, length: {maximum: 255}
    validates :platform_note_description, length: {maximum: 30000}
end
