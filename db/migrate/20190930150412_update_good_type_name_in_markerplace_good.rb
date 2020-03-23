class UpdateGoodTypeNameInMarkerplaceGood < ActiveRecord::Migration[5.2]
  def change
    rename_column :marketplace_goods, :good_type, :good_status
  end
end
