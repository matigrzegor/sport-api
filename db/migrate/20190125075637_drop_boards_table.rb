class DropBoardsTable < ActiveRecord::Migration[5.2]
    def up
      drop_table :boards
    end

    def down
      raise ActiveRecord::IrreversibleMigration
    end
end
