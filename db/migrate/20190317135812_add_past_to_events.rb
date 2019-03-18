class AddPastToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :past, :boolean, default: false
  end
end
