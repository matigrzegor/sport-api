class RenameAmmountsColumnsInTiles < ActiveRecord::Migration[5.2]
  def change
    rename_column :tiles, :tile_activities_sets_rest_ammount, :tile_activities_sets_rest_amount
    rename_column :tiles, :tile_activities_sets_rest_intensity_ammount, :tile_activities_sets_rest_intensity_amount
  end
end
