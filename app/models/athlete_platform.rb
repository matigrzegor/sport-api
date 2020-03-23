class AthletePlatform < ApplicationRecord
    # associations with users
    has_many :memberships
    has_many :users, through: :memberships, dependent: :destroy
    
    # associations with training plans
    has_many :plan_appends
    has_many :training_plans, through: :plan_appends, dependent: :destroy

    # associations with custom athlete parameters
    has_many :custom_athlete_parameters, dependent: :destroy

    # associations with platform notes
    has_many :platform_notes, dependent: :destroy

    # associations with invitations
    has_many :invitations, dependent: :destroy

    # associations with pending user invitations
    has_many :pending_user_invitations, dependent: :destroy

    # associations with platform_chats
    has_many :platform_chats, dependent: :destroy

    # presence validations
    validates :athlete_name, presence: true

    # length validations
    validates :athlete_name, :athlete_phone_number, :athlete_email, :athlete_sport_discipline,
              :athlete_age, :athlete_height, :athlete_weight, :athlete_arm,
              :athlete_chest, :athlete_waist, :athlete_hips, :athlete_tigh, length: {maximum: 255}
end
