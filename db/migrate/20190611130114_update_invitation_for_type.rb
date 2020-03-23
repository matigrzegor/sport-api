class UpdateInvitationForType < ActiveRecord::Migration[5.2]
  def change
    change_column :invitations, :platform_token, :string
  end
end
