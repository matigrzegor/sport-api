class UpdateTileForDefaultNil < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tiles, :tile_type_name, nil
    change_column_default :tiles, :tile_type_color, nil
  end
end
