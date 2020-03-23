class UpdatePlatformChatOne < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :platform_chats, column: :athlete_platform_id
    add_index :platform_chats, :trainer_auth_sub
    add_index :platform_chats, :athlete_auth_sub
    add_column :platform_chats, :messages_read, :boolean, null: false
  end
end
