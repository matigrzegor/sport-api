class AddTileAnswersDescriptivesToTileQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :tile_questions, :tile_answears_descriptives, :text
  end
end
