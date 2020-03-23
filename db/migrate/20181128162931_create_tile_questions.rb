class CreateTileQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :tile_questions do |t|
      t.string :tile_ask_question
      t.boolean :tile_answear_numeric
      t.integer :tile_answear_numeric_from
      t.integer :tile_answear_numeric_to
      t.string :tile_answear_descriptive, array: true, default: [] 
      t.references :tile, index: true, foreign_key: true

      t.timestamps
    end
  end
end
