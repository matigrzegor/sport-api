class RemoveTileAnswearDescriptiveFromTileQuestion < ActiveRecord::Migration[5.2]
  def change
    remove_column :tile_questions, :tile_answear_descriptive, :string
  end
end
