class CreateBoardNotesBad < ActiveRecord::Migration[5.2]
  def change
    create_table :board_notes do |t|
      t.string :board_note_name
      t.string :board_note_link
      t.text :board_note_description
      t.references :board, index: true, foreign_key: true

      t.timestamps
    end
  end
end
