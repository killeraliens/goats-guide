class RemoveEventCreatorInEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :event_creator_id
    remove_column :events, :event_creator_type
    add_column :events, :creator_id, :integer, index: true
  end
end
