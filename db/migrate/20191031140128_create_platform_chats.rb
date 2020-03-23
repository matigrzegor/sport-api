class CreatePlatformChats < ActiveRecord::Migration[5.2]
  def change
    create_table :platform_chats do |t|
      t.belongs_to :athlete_platform, foreign_key: true, index: true
      t.string :trainer_id, null: false
      t.string :athlete_id, null: false

      t.timestamps
    end
  end
end
