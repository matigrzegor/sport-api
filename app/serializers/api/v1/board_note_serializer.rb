module Api::V1

    module BoardNoteSerializer

        def serialize_board_note(board_note)
            {
                id: board_note.id,
                board_note_name: board_note.board_note_name,
                board_note_link: board_note.board_note_link,
                board_note_description: board_note.board_note_description
            }
        end
        
        def serialize_board_notes(board_notes)
            board_notes.map do |board_note|
                serialize_board_note(board_note)
            end
        end

    end

end