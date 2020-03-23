class AddRestAfterActivityFieldsToTileActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :tile_activities, :tile_activity_rest_after_activity_unit, :string
    add_column :tile_activities, :tile_activity_rest_after_activity_amount, :string
    add_column :tile_activities, :tile_activity_rest_after_activity_intensity, :string
    add_column :tile_activities, :tile_activity_rest_after_activity_intensity_amount, :string
  end
end
