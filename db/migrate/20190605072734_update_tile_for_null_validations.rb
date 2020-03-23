class UpdateTileForNullValidations < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tiles, :tile_type, false
    change_column_null :tiles, :tile_type_name, false
    change_column_null :tiles, :tile_type_color, false
  end
end
