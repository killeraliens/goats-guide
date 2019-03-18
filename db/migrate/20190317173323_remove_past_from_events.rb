class RemovePastFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :past, :boolean
  end
end
