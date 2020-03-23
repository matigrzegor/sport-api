class User < ApplicationRecord
    # tiles associations
    has_many :tiles, dependent: :destroy

    # answer notification data associations
    has_many :answer_notification_data, dependent: :destroy

    # tiles associations
    has_many :tags, dependent: :destroy
    
    # training_plans associations
    has_many :training_plans, dependent: :destroy

    # board_notes associations
    has_many :board_notes, as: :boardable, dependent: :destroy

    # athlete_platforms associations
    has_many :memberships
    has_many :athlete_platforms, through: :memberships, dependent: :destroy

    # presence validation
    validates :auth_sub, presence: true

    # uniqueness validation
    validates :auth_sub, uniqueness: true

    # length validation
    validates :auth_sub, :stripe_customer_id, length: {maximum: 255}


    def create_athlete_platform_as_founder(athlete_platform_params)
        athlete_platform = self.athlete_platforms.create!(athlete_platform_params)
        athlete_platform.memberships.find_by_user_id(self.id).founder!
        
        athlete_platform
    end

end
