class Room < ApplicationRecord
  has_many :bookings
  has_many :users, through: :bookings

  validates :number, presence: true, uniqueness: true
end
