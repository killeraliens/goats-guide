class Event < ApplicationRecord
  belongs_to :venue
  belongs_to :creator, foreign_key: "creator_id", class_name: "User", optional: true
  has_many :saved_events, dependent: :destroy
  validates :title, :date, presence: true
  validates :title, :description, case_sensitive: false
  validates :date, uniqueness: { scope: :venue }
  scope :past_events, -> { where("end_date < ?", Date.today) }
  scope :upcoming_events, -> { where("date >= ?", Date.today) }
  mount_uploader :photo, PhotoUploader
  include PgSearch
  pg_search_scope :global_search,
    against: %i[title description date],
    associated_against: {
      venue: %i[name info city state country],
      creator: [:username]
    },
    using: {
      tsearch: { prefix: true }
    }

  def date_format
    date.strftime('%a, %b %d,  %Y')
  end

  def end_date_format
    end_date&.strftime('%a, %b %d, %Y')
  end

  def location
    "#{venue.city} " + "#{venue.state} " + "- #{venue.country} - #{venue.name}"
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
