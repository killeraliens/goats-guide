class RemoveAddressFromVenues < ActiveRecord::Migration[5.2]
  def change
    remove_column :venues, :address, :string
  end
end
