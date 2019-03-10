class Event < ApplicationRecord

  def date_format
    self.date.strftime('%a, %m %d, %Y')
  end
end
