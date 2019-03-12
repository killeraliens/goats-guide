class AddStreetAddressToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :street_address, :string
  end
end
