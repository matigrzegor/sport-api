class CreateQuestionAnswerMetadata < ActiveRecord::Migration[5.2]
  def change
    create_table :question_answer_metadata do |t|
      t.belongs_to :training_plan, foreign_key: true, index: true
      t.integer :training_sesion, null: false
      t.string :calendar_date, null: false
      t.integer :tile_id, null: false
      t.boolean :question_answered, default: false

      t.timestamps
    end
  end
end
