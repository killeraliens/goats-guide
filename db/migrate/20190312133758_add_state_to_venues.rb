class AddStateToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :state, :string
  end
end
