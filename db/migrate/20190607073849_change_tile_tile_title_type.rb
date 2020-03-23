class ChangeTileTileTitleType < ActiveRecord::Migration[5.2]
  def change
    change_column :tiles, :tile_title, :string
  end
end
