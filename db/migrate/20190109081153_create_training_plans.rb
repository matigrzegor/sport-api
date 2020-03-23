class CreateTrainingPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :training_plans do |t|
      t.string :training_plan_name, index: true, null: false
      t.string :date_from, null: false
      t.string :date_to, null: false
      t.integer :training_sesion_number, default: 1

      t.timestamps
    end
  end
end
