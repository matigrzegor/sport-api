class BoardNote < ApplicationRecord
    # polymorphic association - in our instance with user and training_plan
    belongs_to :boardable, polymorphic: true

    # presence validations
    validates :board_note_name, presence: true

    # length validations
    validates :board_note_name, :board_note_link, length: {maximum: 255}
    validates :board_note_description, length: {maximum: 30000}
end
