class Band < ApplicationRecord
  validates :name, uniqueness: true
  after_save :async_search

  private

  def async_search
    SkScrapeJob.perform_later(self.id)
  end
end
