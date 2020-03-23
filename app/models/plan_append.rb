class PlanAppend < ApplicationRecord
    enum plan_activity_status: { inactivated: 0, activated: 1 }
    
    belongs_to :training_plan
    belongs_to :athlete_platform

    # presence validations
    validates :training_plan_name, presence: true

    # length validations
    validates :training_plan_name, length: {maximum: 255}

    # custom validations
    validate :validate_plan_activity_status
    validate :validate_whether_plan_is_already_appended
    validate :validate_whether_plan_and_platform_belong_to_the_same_user
    validate :validate_number_of_plan_appends_on_platform

    def activate_on_platform
        if self.athlete_platform != nil
            self.athlete_platform.plan_appends.each do |plan_append|
                plan_append.inactivated!
            end
        end

        self.activated!
    end

    private

        def validate_plan_activity_status
            if self.athlete_platform != nil
                if self.plan_activity_status == "activated"
                    if self.athlete_platform.plan_appends.where(plan_activity_status: "activated").count > 0
                        errors.add(:plan_activity_status, "activated can be only one per platform")
                    end
                end
            end
        end

        def validate_number_of_plan_appends_on_platform
            if self.new_record? && self.athlete_platform != nil
                if self.athlete_platform.plan_appends.count > 0
                    errors.add(:plan_append, "can be only one per platform")
                end
            end
        end

        def validate_whether_plan_is_already_appended
            if self.new_record? && self.training_plan != nil
                if self.training_plan.plan_appends.count > 0
                    errors.add(:base, "Training plan can be appended to only one platform")
                end
            end
        end

        def validate_whether_plan_and_platform_belong_to_the_same_user
            if self.athlete_platform != nil && self.training_plan != nil
                memberships = self.athlete_platform.memberships.where(membership_status: "founder")
                if memberships.count == 1
                    if memberships.first.user != nil && self.training_plan.user != nil
                        if memberships.first.user != self.training_plan.user
                            errors.add(:base, "Training plan and athlete platform must belong to the same user")
                        end
                    end
                end
            end
        end
end

