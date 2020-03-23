class AddAssoIndexInArrayToCalendarAssocs < ActiveRecord::Migration[5.2]
  def change
    add_column :calendar_assocs, :asso_index_in_array, :text
  end
end
