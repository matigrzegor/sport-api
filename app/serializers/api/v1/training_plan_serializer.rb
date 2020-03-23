module Api::V1

    module TrainingPlanSerializer
        include Api::V1::CalendarAssocSerializer
        include Api::V1::CalendarStarSerializer
        include Api::V1::CalendarCommentSerializer

        def serialize_training_plan(training_plan)
            {
                id: training_plan.id,
                training_plan_name: training_plan.training_plan_name,
                date_from: training_plan.date_from,
                date_to: training_plan.date_to,
                training_sesion_number: training_plan.training_sesion_number
            }
        end
        
        def serialize_full_training_plan(training_plan)
            calendar_assocs = training_plan.calendar_assocs
            calendar_stars = training_plan.calendar_stars
            calendar_comments = training_plan.calendar_comments
            {
                id: training_plan.id,
                training_plan_name: training_plan.training_plan_name,
                date_from: training_plan.date_from,
                date_to: training_plan.date_to,
                training_sesion_number: training_plan.training_sesion_number,
                calendar_assocs: serialize_calendar_assocs(calendar_assocs),
                calendar_stars: serialize_calendar_stars(calendar_stars),
                calendar_comments: serialize_calendar_comments(calendar_comments)
            }
        end

        def serialize_training_plans(athlete_platform)
            athlete_platform.training_plans.map do |training_plan|
                serialize_training_plan(training_plan)
            end
        end

        def serialize_platform_training_plan(training_plan)
            calendar_assocs = training_plan.calendar_assocs.includes(tile: [:tile_activities, :tile_questions,
                                                            :tile_motivation, tile_diets: :tile_diet_nutrients])
            {
                id: training_plan.id,
                training_plan_name: training_plan.training_plan_name,
                date_from: training_plan.date_from,
                date_to: training_plan.date_to,
                training_sesion_number: training_plan.training_sesion_number,
                calendar_assocs: serialize_calendar_assocs(calendar_assocs)
            }
        end

        def serialize_index_training_plans(training_plans)
            training_plans.map do |training_plan|
                athlete_platforms = training_plan.athlete_platforms
                athlete_platforms_count = athlete_platforms.count
                
                if athlete_platforms_count == 1
                    {
                        id: training_plan.id,
                        training_plan_name: training_plan.training_plan_name,
                        training_plan_athlete: athlete_platforms.first.athlete_name,
                        training_plan_active: true
                    }
                elsif athlete_platforms_count == 0
                    {
                        id: training_plan.id,
                        training_plan_name: training_plan.training_plan_name
                    }
                end
            end
        end

    end

end

