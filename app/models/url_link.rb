class UrlLink < ApplicationRecord
  belongs_to :user
  # validates :link (on length)
  validates_format_of :url, with: URI::regexp(%w(http https))
  before_validation :format_url

  def format_url
    self.url = "http://#{self.url}" unless self.url[/^https?/]
  end
end
