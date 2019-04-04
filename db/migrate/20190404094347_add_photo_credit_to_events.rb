class AddPhotoCreditToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :photo_credit, :string
  end
end
