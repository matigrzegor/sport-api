class AddIndexOnPlatformTokenInInvitation < ActiveRecord::Migration[5.2]
  def change
    add_index :invitations, :platform_token
  end
end
