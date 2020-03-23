module Api::V1

    module CalendarAssocSerializer

        def serialize_calendar_assoc(calendar_assoc)
            {
                id: calendar_assoc.id,
                tile_id: calendar_assoc.tile_id,
                training_plan_id: calendar_assoc.training_plan_id,
                tile_color: calendar_assoc.tile_color,
                calendar_date: calendar_assoc.calendar_date,
                training_sesion: calendar_assoc.training_sesion,
                asso_index_in_array: calendar_assoc.asso_index_in_array
            }
        end
        
        def serialize_calendar_assocs(calendar_assocs)
            calendar_assocs.map do |calendar_assoc|
                serialize_calendar_assoc(calendar_assoc)
            end
        end

    end

end