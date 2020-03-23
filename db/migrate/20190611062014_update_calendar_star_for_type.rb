class UpdateCalendarStarForType < ActiveRecord::Migration[5.2]
  def change
    change_column :calendar_stars, :star_color, :string
  end
end
