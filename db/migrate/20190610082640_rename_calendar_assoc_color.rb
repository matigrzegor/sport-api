class RenameCalendarAssocColor < ActiveRecord::Migration[5.2]
  def change
    rename_column :calendar_assocs, :color, :tile_color
  end
end
