class DropAssociationsTable < ActiveRecord::Migration[5.2]
    def up
      drop_table :associations
    end

    def down
      raise ActiveRecord::IrreversibleMigration
    end
end
