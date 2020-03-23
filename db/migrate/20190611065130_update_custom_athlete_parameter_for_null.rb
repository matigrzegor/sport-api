class UpdateCustomAthleteParameterForNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :custom_athlete_parameters, :parameter_name, false
    change_column_null :custom_athlete_parameters, :parameter_date, false
    change_column_null :custom_athlete_parameters, :parameter_description, false
  end
end
