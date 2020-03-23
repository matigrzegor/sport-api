class UpdateAssoIndexInArrayToCalendarAssocs < ActiveRecord::Migration[5.2]
  def change
    change_column :calendar_assocs, :asso_index_in_array, 'integer USING CAST(asso_index_in_array AS integer)'
  end
end
