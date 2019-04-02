class UrlLink < ApplicationRecord
  belongs_to :user
  # validates :link (on length)
  # validates :url (http regex)
end
