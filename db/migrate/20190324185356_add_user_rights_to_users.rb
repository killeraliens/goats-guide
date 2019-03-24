class AddUserRightsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :user_rights, foreign_key: true
  end
end
