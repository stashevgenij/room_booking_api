require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:bookings) }
  it { should have_many(:rooms).through(:bookings) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
end