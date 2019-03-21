class ScrapeJob < ApplicationRecord
  has_many :events, as: :event_creator, dependent: :destroy
end
