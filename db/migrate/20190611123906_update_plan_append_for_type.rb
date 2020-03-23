class UpdatePlanAppendForType < ActiveRecord::Migration[5.2]
  def change
    change_column :plan_appends, :training_plan_name, :string
  end
end
