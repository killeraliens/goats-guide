class AddLinkToUrlLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :url_links, :link, :string
  end
end
