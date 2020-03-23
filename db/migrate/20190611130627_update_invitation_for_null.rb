class UpdateInvitationForNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :invitations, :platform_token, false
    change_column_null :invitations, :recipient_id, false
  end
end
