class UpdateAssoIndexInArrayNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :calendar_assocs, :asso_index_in_array, false
  end
end
