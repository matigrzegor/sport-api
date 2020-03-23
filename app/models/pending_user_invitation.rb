class PendingUserInvitation < ApplicationRecord
    belongs_to :athlete_platform

    # presence validations
    validates :athlete_identifier, presence: true

    # length validations
    validates :athlete_identifier, length: {maximum: 255}

    # custom validations
    validate :validate_number_of_athlete_invitation_statuses_on_platform

    private

        def validate_number_of_athlete_invitation_statuses_on_platform
            if self.new_record? && self.athlete_platform != nil
                if self.athlete_platform.pending_user_invitations.count >= 1 ||
                            self.athlete_platform.invitations.count >= 1 ||
                            self.athlete_platform.memberships.where(membership_status: "attendant").count >= 1
                    errors.add(:base, "Platform can have only one type of athlete invitation status")
                end
            end
        end
end

