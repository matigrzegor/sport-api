class CreateCalendarComments < ActiveRecord::Migration[5.2]
  def change
    create_table :calendar_comments do |t|
      t.belongs_to :training_plan, foreign_key: true, index: true
      t.string :comment_user, null: false
      t.string :comment_data, null: false
      t.text :comment_body

      t.timestamps
    end
  end
end
