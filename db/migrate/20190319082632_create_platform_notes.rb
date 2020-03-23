class CreatePlatformNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :platform_notes do |t|
      t.belongs_to :athlete_platform, foreign_key: true, index: true
      
      t.text :platform_note_name, null: false
      t.text :platform_note_link
      t.text :platform_note_description
      
      t.timestamps
    end
  end
end
