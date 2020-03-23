module Api::V1
    
    module AthletePlatformSerializer
        include Api::V1::PlatformNoteSerializer
        include Api::V1::CustomAthleteParameterSerializer
        include Api::V1::TrainingPlanSerializer
        include Api::V1::PlanAppendSerializer


        def serialize_athlete_platforms(athlete_platforms)
            athlete_platforms.map do |athlete_platform|
                {
                    id: athlete_platform.id,
                    athlete_name: athlete_platform.athlete_name,
                    activated_training_plan: serialize_active_plan(athlete_platform)
                }
            
            end
        end
    
        def serialize_athlete_platform(athlete_platform)
            {
                id: athlete_platform.id,
                athlete_name: athlete_platform.athlete_name,
                athlete_phone_number: athlete_platform.athlete_phone_number,
                athlete_email: athlete_platform.athlete_email,
                athlete_sport_discipline: athlete_platform.athlete_sport_discipline,
                athlete_age: athlete_platform.athlete_age,
                athlete_height: athlete_platform.athlete_height,
                athlete_weight: athlete_platform.athlete_weight,
                athlete_arm: athlete_platform.athlete_arm,
                athlete_chest: athlete_platform.athlete_chest,
                athlete_waist: athlete_platform.athlete_waist,
                athlete_hips: athlete_platform.athlete_hips,
                athlete_tigh: athlete_platform.athlete_tigh,
                fitness_level: athlete_platform.fitness_level
            }
        end

        def serialize_full_athlete_platform(athlete_platform, hash_to_merge)
            {
                id: athlete_platform.id,
                athlete_name: athlete_platform.athlete_name,
                athlete_phone_number: athlete_platform.athlete_phone_number,
                athlete_email: athlete_platform.athlete_email,
                athlete_sport_discipline: athlete_platform.athlete_sport_discipline,
                athlete_age: athlete_platform.athlete_age,
                athlete_height: athlete_platform.athlete_height,
                athlete_weight: athlete_platform.athlete_weight,
                athlete_arm: athlete_platform.athlete_arm,
                athlete_chest: athlete_platform.athlete_chest,
                athlete_waist: athlete_platform.athlete_waist,
                athlete_hips: athlete_platform.athlete_hips,
                athlete_tigh: athlete_platform.athlete_tigh,
                fitness_level: athlete_platform.fitness_level,
                custom_athlete_parameters: serialize_custom_athlete_parameters(athlete_platform),
                platform_notes: serialize_platform_notes(athlete_platform),
                #training_plans: serialize_training_plans(athlete_platform),
                plan_appends: serialize_plan_appends(athlete_platform)     
        }.merge(hash_to_merge)
        end

        private

            def serialize_active_plan(athlete_platform)
                if athlete_platform.plan_appends.find_by_plan_activity_status("activated").nil?
                    nil
                else
                    athlete_platform.plan_appends.find_by_plan_activity_status("activated").slice(:training_plan_id,
                                                                                                 :training_plan_name)
                end
            end

    end

end
