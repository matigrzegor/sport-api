class UpdateTrainingTileFromIntegerToString < ActiveRecord::Migration[5.2]
  def change
    change_column :tiles, :tile_activities_sets_rest_ammount, :string
    change_column :tiles, :tile_activities_sets_rest_intensity_ammount, :string
    change_column :tile_activities, :tile_activity_amount, :string
    change_column :tile_activities, :tile_activity_intensity_amount, :string
    change_column :tile_activities, :tile_activity_rest_amount, :string
    change_column :tile_activities, :tile_activity_rest_intensity_amount, :string
  end
end
