class User < ApplicationRecord
  has_many :events
  has_many :saved_events
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: :true, uniqueness: { case_sensitive: false }

end
