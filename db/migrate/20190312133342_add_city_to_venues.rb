class AddCityToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :city, :string
  end
end
