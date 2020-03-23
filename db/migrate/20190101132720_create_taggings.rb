class CreateTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :taggings do |t|
      t.belongs_to :tag, foreign_key: true, index: true
      t.belongs_to :tile, foreign_key: true, index: true

      t.timestamps
    end
  end
end
