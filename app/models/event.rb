class Event < ApplicationRecord
  belongs_to :venue
  has_many :saved_events

  def date_format
    self.date.strftime('%a, %m %d, %Y')
  end

  def descript_limit
    self.description.truncate(122)
  end
end
