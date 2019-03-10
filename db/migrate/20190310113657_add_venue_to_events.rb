class AddVenueToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :venue, foreign_key: true
  end
end
