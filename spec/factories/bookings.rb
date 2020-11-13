FactoryBot.define do
  factory :booking do
    sequence(:start_date) { |n| Time.now + n.days }
    sequence(:end_date)   { |n| Time.now + (n + 1).days }
    user
    room
  end
end
