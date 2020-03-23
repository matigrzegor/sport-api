class PlatformChat < ApplicationRecord
    belongs_to :athlete_platform
    has_many :platform_messages, dependent: :destroy

    # presence validations
    validates :trainer_auth_sub, :athlete_auth_sub, presence: true

    # length validations
    validates :trainer_auth_sub, :athlete_auth_sub, length: {maximum: 255}

end
