class UpdateMembershipsForDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :memberships, :membership_status, nil
  end
end
