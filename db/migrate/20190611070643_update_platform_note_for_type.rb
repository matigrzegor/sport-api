class UpdatePlatformNoteForType < ActiveRecord::Migration[5.2]
  def change
    change_column :platform_notes, :platform_note_name, :string
    change_column :platform_notes, :platform_note_link, :string
  end
end
