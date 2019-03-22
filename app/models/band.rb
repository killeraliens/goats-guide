class Band < ApplicationRecord
  validates :name, uniqueness: true
end
