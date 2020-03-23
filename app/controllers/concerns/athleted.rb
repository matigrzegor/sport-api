module Athleted
    extend ActiveSupport::Concern
    
    included do
        before_action :current_plan_append, only: [:show, :create, :index]
    end

    private

        def current_plan_append
            memberships = @extracted_user.memberships.where(membership_status: 'attendant')
            if memberships.count == 1
                activated_plan_appends = memberships.first.athlete_platform.plan_appends
                                            .where(plan_activity_status: 'activated')
                if activated_plan_appends.count == 1
                    @plan_append = activated_plan_appends.first
                elsif activated_plan_appends.count == 0
                    render json: {message: "Your trainer have not activated any plan yet"}, status: :ok
                end
            elsif memberships.count == 0
                render json: {message: "You have not been invited to any group yet"}, status: :ok
            end
        end

end