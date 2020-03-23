module Api::V1

    module PlanAppendSerializer

        def serialize_plan_append(plan_append)
            {
                id: plan_append.id,
                training_plan_id: plan_append.training_plan_id,
                athlete_platform_id: plan_append.athlete_platform_id,
                plan_activity_status: plan_append.plan_activity_status
            }
        end

        def serialize_plan_appends(athlete_platform)
            athlete_platform.plan_appends.map do |plan_append|
                serialize_plan_append(plan_append)
            end
        end

    end

end