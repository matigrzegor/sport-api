class CreateCalendarAssocs < ActiveRecord::Migration[5.2]
  def change
    create_table :calendar_assocs do |t|
      t.belongs_to :tile, foreign_key: true, index: true
      t.belongs_to :training_plan, foreign_key: true, index: true
      t.string :date, null: false
      t.string :color, null: false
      t.integer :training_sesion, default: 1

      t.timestamps
    end
  end
end
