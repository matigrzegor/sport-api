class UpdateAttrbiutesToNumbersInUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :account_level, 'integer USING CAST(account_level AS integer)'
    change_column :users, :current_paid_access_start_date, 'integer USING CAST(current_paid_access_start_date AS integer)'
    change_column :users, :current_paid_access_end_date, 'integer USING CAST(current_paid_access_end_date AS integer)'
    change_column :users, :paid_access_start_date, 'integer USING CAST(paid_access_start_date AS integer)'
    change_column :users, :trial_start_date, 'integer USING CAST(trial_start_date AS integer)'
    change_column :users, :trial_end_date, 'integer USING CAST(trial_end_date AS integer)'
  end
end
