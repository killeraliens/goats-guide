class CreateUserRights < ActiveRecord::Migration[5.2]
  def change
    create_table :user_rights do |t|
      t.boolean :admin, default: false
      t.boolean :general, default: true
      t.boolean :event_admin, default: false

      t.timestamps
    end
  end
end
