module Api::V1

    module CustomAthleteParameterSerializer

        def serialize_custom_athlete_parameter(custom_athlete_parameter)
            {
                id: custom_athlete_parameter.id,
                parameter_name: custom_athlete_parameter.parameter_name,
                parameter_date: custom_athlete_parameter.parameter_date,
                parameter_description: custom_athlete_parameter.parameter_description
            }
        end
        
        def serialize_custom_athlete_parameters(athlete_platform)
            athlete_platform.custom_athlete_parameters.map do |custom_athlete_parameter|
                serialize_custom_athlete_parameter(custom_athlete_parameter)
            end
        end

    end

end