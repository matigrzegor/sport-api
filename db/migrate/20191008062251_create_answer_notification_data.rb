class CreateAnswerNotificationData < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_notification_data do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.string :time_tags, null: false

      t.timestamps
    end
  end
end
