class User < ApplicationRecord
  has_many :events, foreign_key: :creator_id, dependent: :destroy
  has_many :saved_events, dependent: :destroy
  has_many :url_links, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  # validates :city, :country, presence: true
  mount_uploader :photo, PhotoUploader

  def address
    [city, state, country].compact.join(', ')
  end
end
