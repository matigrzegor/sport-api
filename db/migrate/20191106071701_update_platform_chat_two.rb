class UpdatePlatformChatTwo < ActiveRecord::Migration[5.2]
  def change
    remove_column :platform_chats, :messages_read
    add_column :platform_chats, :athlete_username, :string
    add_column :platform_chats, :trainer_username, :string
    add_column :platform_chats, :athlete_avatar, :string
    add_column :platform_chats, :trainer_avatar, :string
  end
end
