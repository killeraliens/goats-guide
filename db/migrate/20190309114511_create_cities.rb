class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.boolean :state
      t.string :state_name
      t.string :country_name
      t.string :continent_name

      t.timestamps
    end
  end
end
