class AddEventCreatorToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :event_creator, polymorphic: true, index: true
  end
end
