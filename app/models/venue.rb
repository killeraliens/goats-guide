class Venue < ApplicationRecord
  has_many :events, dependent: :destroy
  validates :name, :city, :country, presence: true
  validates :name, :street_address, :city, :state, :country, case_sensitive: false
  validates :name, uniqueness: { scope: :city }
  geocoded_by :address
  after_validation :geocode

  def address
    [city, state, country].compact.join(', ')
  end
end
