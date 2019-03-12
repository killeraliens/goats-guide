class Venue < ApplicationRecord
  has_many :events, dependent: :destroy
  validates :name, :city, :country, presence: true
  validates :name, :street_address, :city, :state, :country, case_sensitive: false
  validates :name, uniqueness: { scope: :street_address }
  #validates :address, uniqueness: true
end
