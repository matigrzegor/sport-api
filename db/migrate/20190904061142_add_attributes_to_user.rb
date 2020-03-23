class AddAttributesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_level, :string
    add_column :users, :current_paid_access_start_date, :string
    add_column :users, :current_paid_access_end_date, :string
    add_column :users, :paid_access_start_date, :string
    add_column :users, :trial_start_date, :string
    add_column :users, :trial_end_date, :string
  end
end
