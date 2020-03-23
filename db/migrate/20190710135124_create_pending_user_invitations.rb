class CreatePendingUserInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :pending_user_invitations do |t|
      t.belongs_to :athlete_platform, foreign_key: true, index: true
      t.string :athlete_identifier, null: false
      t.string :expiration_date, null: false

      t.timestamps
    end
  end
end
