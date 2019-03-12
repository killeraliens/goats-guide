class AddCountryToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :country, :string
  end
end
