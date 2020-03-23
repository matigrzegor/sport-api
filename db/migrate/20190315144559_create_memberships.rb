class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.belongs_to :athlete_platform, foreign_key: true, index: true
      t.integer :membership_status, default: 0

      t.timestamps
    end
  end
end
