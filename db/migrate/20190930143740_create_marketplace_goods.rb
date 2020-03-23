class CreateMarketplaceGoods < ActiveRecord::Migration[5.2]
  def change
    create_table :marketplace_goods do |t|
      t.string :good_id, null: false
      t.string :good_database_model, null: false
      t.string :good_creator, null: false
      t.string :good_type, null: false
      t.string :good_description
      t.text :good_content, null: false

      t.timestamps
    end
  end
end
