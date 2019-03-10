class Venue < ApplicationRecord
  has_many :events, dependent: :destroy
  validates :name, :address, presence: true
  validates :address, uniqueness: true
end
