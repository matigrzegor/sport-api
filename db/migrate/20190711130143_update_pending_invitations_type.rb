class UpdatePendingInvitationsType < ActiveRecord::Migration[5.2]
  def change
    change_column :pending_user_invitations, :expiration_date, 'integer USING CAST(expiration_date AS integer)'
  end
end
