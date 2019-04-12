class User < ApplicationRecord
  has_many :events, foreign_key: :creator_id, dependent: :destroy
  has_many :saved_events, dependent: :destroy
  has_many :url_links, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :city, :state, :country, presence: true
  validates :username, length: {
    maximum: 15,
    too_long: "%{count} characters is the maximum allowed"
  }
  validates :quote, length: {
    maximum: 48,
    too_long: "%{count} characters is the maximum allowed"
  }
  mount_uploader :photo, PhotoUploader
  include PgSearch
  pg_search_scope :search_by_username_country_state_city,
    against: %i[username country state city],
    using: {
      tsearch: { prefix: true }
    }
  geocoded_by :address
  after_validation :geocode # , if: :will_save_change_to_address?

  def address
    [city, state, country].compact.join(', ')
  end
end
