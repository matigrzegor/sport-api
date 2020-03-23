class UpdateUserAuthSubForNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :auth_sub, false
  end
end
