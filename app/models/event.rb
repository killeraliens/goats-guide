class Event < ApplicationRecord
  belongs_to :venue
  has_many :saved_events
  validates :title, :date, presence: true
  validates :title, :description, case_sensitive: false
  validates :date, uniqueness: { scope: :venue }

  def date_format
    date.strftime('%a, %b %d,  %Y')
  end

  def end_date_format
    end_date.strftime('%a, %b %d, %Y')
  end

  def descript_limit
    description.truncate(122)
  end

  def past
    if end_date.nil? && date < Date.today
      past
    elsif !end_date.nil? && end_date < Date.today
      past
    end
  end

  def country
  end
end
