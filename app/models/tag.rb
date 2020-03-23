class Tag < ApplicationRecord
    has_many :taggings
    has_many :tiles, through: :taggings, dependent: :destroy

    belongs_to :user

    # presence validations
    validates :tag_name, presence: true

    # length validations
    validates :tag_name, length: {maximum: 255}
end
