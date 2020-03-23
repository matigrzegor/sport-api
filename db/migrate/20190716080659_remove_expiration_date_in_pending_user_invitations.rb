class RemoveExpirationDateInPendingUserInvitations < ActiveRecord::Migration[5.2]
  def change
    remove_column :pending_user_invitations, :expiration_date, :integer
  end
end
