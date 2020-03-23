class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.belongs_to :athlete_platform, foreign_key: true, index: true
      t.text :platform_token
      t.string :recipient_id

      t.timestamps
    end
  end
end
