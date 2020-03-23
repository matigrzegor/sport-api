class RemoveNullFalseInTilesAssociations < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tile_activities, :tile_activity_name, true
    change_column_null :tile_diet_nutrients, :tile_diet_nutrient_name, true
    change_column_null :tile_diets, :tile_diet_meal, true
    change_column_null :tile_motivations, :tile_motivation_sentence, true
    change_column_null :tile_questions, :tile_ask_question, true
  end
end
