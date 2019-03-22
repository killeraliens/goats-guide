class Band < ApplicationRecord
  validates :name, uniqueness: true
  # after_create :async_search

  # private

  # def async_search
  #   SkScrapeJob.perform_later(id)
  # end
end
