class Event < ApplicationRecord
  belongs_to :venue
  has_many :saved_events
  validates :title, :date, presence: true
  validates :title, :description, case_sensitive: false
  validates :date, uniqueness: { scope: :venue }
  # scope :past_events, where('past is not null')
  # scope :upcoming_events, where('past is null')
  # scope :query, ->(query) { where("query like ?", "%#{query}%") }
  # scope :query, lambda {|query| where(["query LIKE :term", {term: "%#{query}%"}]) }

  def date_format
    date.strftime('%a, %b %d,  %Y')
  end

  def end_date_format
    end_date.strftime('%a, %b %d, %Y') if end_date
  end

  def descript_limit
    description.truncate(122)
  end

  def past
    if end_date.nil? && date < Date.today
      true
    elsif end_date && end_date < Date.today
      true
    else
      false
    end
  end

  def self.past_events
    events = []
       Event.all.each { |event| events << event if event.past }
    return events
  end

  def self.upcoming_events
    events = []
    Event.all.each { |event| events << event if !event.past }
    return events
  end
end



