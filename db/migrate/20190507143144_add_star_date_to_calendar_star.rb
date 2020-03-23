class AddStarDateToCalendarStar < ActiveRecord::Migration[5.2]
  def change
    add_column :calendar_stars, :star_date, :string, null: false
  end
end
