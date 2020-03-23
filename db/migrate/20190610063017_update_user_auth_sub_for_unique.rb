class UpdateUserAuthSubForUnique < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :auth_sub, unique: true
  end
end
