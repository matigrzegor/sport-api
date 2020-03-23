class AddRestAttributesToTile < ActiveRecord::Migration[5.2]
  def change
    add_column :tiles, :tile_activities_sets_rest_unit, :string
    add_column :tiles, :tile_activities_sets_rest_ammount, :integer
    add_column :tiles, :tile_activities_sets_rest_intensity_unit, :string
    add_column :tiles, :tile_activities_sets_rest_intensity_ammount, :integer
  end
end
