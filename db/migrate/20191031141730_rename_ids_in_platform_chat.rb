class RenameIdsInPlatformChat < ActiveRecord::Migration[5.2]
  def change
    rename_column :platform_chats, :trainer_id, :trainer_auth_sub
    rename_column :platform_chats, :athlete_id, :athlete_auth_sub
  end
end
