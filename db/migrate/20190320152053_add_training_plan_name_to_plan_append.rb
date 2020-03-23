class AddTrainingPlanNameToPlanAppend < ActiveRecord::Migration[5.2]
  def change
    add_column :plan_appends, :training_plan_name, :text
  end
end
