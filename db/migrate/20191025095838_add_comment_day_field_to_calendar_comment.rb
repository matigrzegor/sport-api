class AddCommentDayFieldToCalendarComment < ActiveRecord::Migration[5.2]
  def change
    add_column :calendar_comments, :comment_day, :string, null: false
  end
end
