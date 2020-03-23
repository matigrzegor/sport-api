module Api::V1

    module PlatformNoteSerializer

        def serialize_platform_note(platform_note)
            {
                id: platform_note.id,
                platform_note_name: platform_note.platform_note_name,
                platform_note_link: platform_note.platform_note_link,
                platform_note_description: platform_note.platform_note_description
            }
        end
        
        def serialize_platform_notes(athlete_platform)
            athlete_platform.platform_notes.map do |platform_note|
                serialize_platform_note(platform_note)
            end
        end

    end

end