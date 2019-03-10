class Event < ApplicationRecord
  belongs_to :venue

  def date_format
    self.date.strftime('%a, %m %d, %Y')
  end
end
