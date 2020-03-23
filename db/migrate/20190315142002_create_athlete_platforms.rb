class CreateAthletePlatforms < ActiveRecord::Migration[5.2]
  def change
    create_table :athlete_platforms do |t|
      t.string :athlete_name, null: false
      t.string :athlete_phone_number
      t.string :athlete_email
      t.string :athlete_sport_discipline
      t.string :athlete_age
      t.string :athlete_height
      t.string :athlete_weight
      t.string :athlete_arm
      t.string :athlete_chest
      t.string :athlete_waist
      t.string :athlete_hips
      t.string :athlete_tigh

      t.timestamps
    end
  end
end
