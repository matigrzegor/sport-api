class UpdateBoardNoteForNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :board_notes, :board_note_name, false
  end
end
