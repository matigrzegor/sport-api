class UpdateCustomAthleteParameterForType < ActiveRecord::Migration[5.2]
  def change
    change_column :custom_athlete_parameters, :parameter_name, :string
  end
end
