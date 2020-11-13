require 'rails_helper'

RSpec.describe Room, type: :model do
  it { should have_many(:bookings) }
  it { should have_many(:users).through(:bookings) }
  it { should validate_presence_of(:number) }
  it { should validate_uniqueness_of(:number) }
end
