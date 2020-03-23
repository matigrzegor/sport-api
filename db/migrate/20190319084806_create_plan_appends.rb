class CreatePlanAppends < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_appends do |t|
      t.belongs_to :training_plan, foreign_key: true, index: true
      t.belongs_to :athlete_platform, foreign_key: true, index: true
      t.integer :plan_activity_status, default: 0

      t.timestamps
    end
  end
end
