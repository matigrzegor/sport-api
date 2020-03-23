class AddUserReferenceToTrainingPlan < ActiveRecord::Migration[5.2]
  def change
    add_reference :training_plans, :user, foreign_key: true, index: true
  end
end
