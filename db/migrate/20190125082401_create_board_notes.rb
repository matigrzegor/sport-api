class CreateBoardNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :board_notes do |t|
      t.string :board_note_name
      t.string :board_note_link
      t.text :board_note_description
      t.references :boardable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
