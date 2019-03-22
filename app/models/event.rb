class Event < ApplicationRecord
  belongs_to :venue
  belongs_to :event_creator, polymorphic: true
  has_many :saved_events
  validates :title, :date, presence: true
  validates :title, :description, case_sensitive: false
  validates :date, uniqueness: { scope: :venue }
  scope :past_events, -> { where("date < ?", Date.today) }
  scope :upcoming_events, -> { where("date >= ?", Date.today) }

  def date_format
    date.strftime('%a, %b %d,  %Y')
  end

  def end_date_format
    end_date.strftime('%a, %b %d, %Y') if end_date
  end

  def descript_limit
    description.truncate(122) if description
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
end


