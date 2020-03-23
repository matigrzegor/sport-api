class CreateTileActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :tile_activities do |t|
      t.string :tile_activity_name, null: false
      t.integer :tile_activity_reps
      t.string :tile_activity_unit
      t.integer :tile_activity_amount
      t.string :tile_activity_intensity
      t.integer :tile_activity_intensity_amount
      t.string :tile_activity_rest_unit
      t.integer :tile_activity_rest_amount
      t.text :tile_activity_note
      t.references :tile, index: true, foreign_key: true

      t.timestamps
    end
  end
end
