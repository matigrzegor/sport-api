class UpdateTileTileDescriptionForDefaultNil < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tiles, :tile_description, nil
  end
end
