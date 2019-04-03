class AddFetchPhotoToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :fetch_photo, :string
  end
end
