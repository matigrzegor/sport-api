class CreateCustomAthleteParameters < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_athlete_parameters do |t|
      t.belongs_to :athlete_platform, foreign_key: true, index: true
      
      t.text :parameter_name
      t.string :parameter_date
      t.text :parameter_description

      t.timestamps
    end
  end
end
