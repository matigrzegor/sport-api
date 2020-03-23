class RenameCalendarAssocsDateToCalendarDate < ActiveRecord::Migration[5.2]
  def change
    rename_column :calendar_assocs, :date, :calendar_date
  end
end
