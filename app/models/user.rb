class User < ApplicationRecord
  has_many :bookings
  has_many :rooms, through: :bookings

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
end
