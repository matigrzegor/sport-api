class AddCommentUserRoleToCalendarComment < ActiveRecord::Migration[5.2]
  def change
    add_column :calendar_comments, :comment_user_role, :string, null: false
  end
end
