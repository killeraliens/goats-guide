class RenameStreetAddressInVenues < ActiveRecord::Migration[5.2]
  def change
    rename_column :venues, :street_address, :street
  end
end
