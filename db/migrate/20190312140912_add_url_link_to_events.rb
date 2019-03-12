class AddUrlLinkToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :url_link, :string
  end
end
