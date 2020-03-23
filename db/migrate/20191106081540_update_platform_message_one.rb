class UpdatePlatformMessageOne < ActiveRecord::Migration[5.2]
  def change
    add_column :platform_messages, :message_read, :boolean, null: false
  end
end
