class UpdatePlanAppendForNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :plan_appends, :training_plan_name, false
  end
end
