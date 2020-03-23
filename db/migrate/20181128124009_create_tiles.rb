class CreateTiles < ActiveRecord::Migration[5.2]
  def change
    create_table :tiles do |t|
      t.string :tile_type
      t.string :tile_type_name, default: ''
      t.string :tile_type_color, default: ''
      t.string :tile_title, null: false
      t.text :tile_description, default: ''
      t.integer :tile_activities_sets, default: 1
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
