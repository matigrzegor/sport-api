class CreateQuestionAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :question_answers do |t|
      t.belongs_to :training_plan, foreign_key: true, index: true
      
      t.integer :question_tile_id
      t.string :question_date
      t.text :question_answer
      t.text :answer_comment

      t.timestamps
    end
  end
end
