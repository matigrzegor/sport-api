class DropBoardNotesTable < ActiveRecord::Migration[5.2]
    def up
      drop_table :board_notes
    end

    def down
      raise ActiveRecord::IrreversibleMigration
    end
end
