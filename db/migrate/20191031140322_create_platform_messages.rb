class CreatePlatformMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :platform_messages do |t|
      t.belongs_to :platform_chat, foreign_key: true, index: true
      t.string :user_auth_sub, null: false
      t.string :message_date, null: false
      t.text :message_text, null: false

      t.timestamps
    end
  end
end
