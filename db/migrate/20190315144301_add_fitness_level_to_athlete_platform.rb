class AddFitnessLevelToAthletePlatform < ActiveRecord::Migration[5.2]
  def change
    add_column :athlete_platforms, :fitness_level, :integer
  end
end
