class User < ApplicationRecord
  has_many :events, as: :event_creator, dependent: :destroy
  has_many :saved_events, dependent: :destroy
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

