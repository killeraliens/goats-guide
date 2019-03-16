class AddInfoToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :info, :string
  end
end
