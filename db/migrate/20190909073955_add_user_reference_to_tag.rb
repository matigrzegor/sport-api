class AddUserReferenceToTag < ActiveRecord::Migration[5.2]
  def change
    add_reference :tags, :user, index: true
  end
end
