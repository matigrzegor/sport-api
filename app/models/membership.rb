class Membership < ApplicationRecord
    enum membership_status: { attendant: 0, founder: 1 }

    belongs_to :user
    belongs_to :athlete_platform

    # custom validations
    validate :validate_membership_status
    validate :validate_number_of_memberships_on_athlete_platform
    validate :validate_number_of_athlete_invitation_statuses_on_platform

    private

        def validate_membership_status
            if self.user != nil && self.athlete_platform != nil
                if self.membership_status == "attendant"
                    if self.user.memberships.where(membership_status: "attendant").count > 0
                        errors.add(:membership_status, "attendant can be only one per user")
                    elsif self.athlete_platform.memberships.where(membership_status: "attendant").count > 0
                        errors.add(:membership_status, "attendant can be only one per platform")
                    end
                elsif self.membership_status == "founder"
                    if self.athlete_platform.memberships.where(membership_status: "founder").count > 0
                        errors.add(:membership_status, "founder can be only one per platform")
                    end
                end
            end
        end

        def validate_number_of_memberships_on_athlete_platform
            if self.new_record? && self.athlete_platform != nil
                if self.athlete_platform.memberships.count >= 2
                    errors.add(:base, "Platform can have only two memberships")
                end
            end
        end

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

