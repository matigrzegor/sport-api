module Api::V1

    module CalendarStarSerializer

        def serialize_calendar_star(calendar_star)
            {
                id: calendar_star.id,
                star_color: calendar_star.star_color,
                star_description: calendar_star.star_description,
                star_date: calendar_star.star_date
            }
        end
        
        def serialize_calendar_stars(calendar_stars)
            calendar_stars.map do |calendar_stars|
                serialize_calendar_star(calendar_stars)
            end
        end

    end

end