class AddRestAttributesToTileActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :tile_activities, :tile_activity_rest_intensity, :string
    add_column :tile_activities, :tile_activity_rest_intensity_amount, :integer
  end
end
