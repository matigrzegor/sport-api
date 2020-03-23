class CreateCalendarStars < ActiveRecord::Migration[5.2]
  def change
    create_table :calendar_stars do |t|
      t.belongs_to :training_plan, foreign_key: true, index: true
      t.text :star_color, null: false
      t.text :star_description

      t.timestamps
    end
  end
end
