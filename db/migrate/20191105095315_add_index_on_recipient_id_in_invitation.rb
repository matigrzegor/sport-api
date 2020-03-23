class AddIndexOnRecipientIdInInvitation < ActiveRecord::Migration[5.2]
  def change
    add_index :invitations, :recipient_id
  end
end
