require 'rails_helper'

RSpec.describe Booking, type: :model do
  let(:user) { create :user }
  let(:room) { create :room }

  describe '(validations)' do
    it { should belong_to(:room) }
    it { should belong_to(:user) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end

  describe '(custom validations)' do
    it 'ensures the end date later than the start date' do
      booking = room.bookings.new(start_date: Time.now, end_date: 1.day.ago, user: user)
      expect(booking.valid?).to eq(false)
    end

    it 'ensures the start date is today or later' do
      booking = room.bookings.new(start_date: 1.day.ago, end_date: Time.now, user: user)
      expect(booking.valid?).to eq(false)
    end

    it 'ensures the dates for one room do not overlap' do
      booking       = room.bookings.create(start_date: Time.now, end_date: 3.days.from_now, user: user)
      other_booking = room.bookings.new(start_date: 1.day.from_now, end_date: 4.days.from_now, user: user)
      expect(other_booking.valid?).to eq(false)
    end

    it 'should save valid booking' do
      booking = build(:booking, user: user, room: room)
      expect(booking.save).to eq(true)
    end

    context 'multiple create' do
      it 'creates no bookings if one or more is invalid' do
        expect do
          bookings = room.bookings.create_multiple([{ start_date: Time.now,
                                                      end_date: 3.days.from_now,
                                                      user: user },
                                                    { start_date: 1.day.from_now,
                                                      end_date: 4.days.from_now,
                                                      user: user }])
        rescue ActiveRecord::RecordInvalid
          nil
        end.not_to change(Booking, :count)
      end

      it 'creates multiple valid bookings' do
        expect do
          bookings = room.bookings.create_multiple([{ start_date: Time.now.to_date,
                                                      end_date: 3.days.from_now,
                                                      user: user,
                                                      room: room },
                                                    { start_date: 3.days.from_now,
                                                      end_date: 5.days.from_now,
                                                      user: user,
                                                      room: room }])
        end.to change(Booking, :count).by(2)
      end
    end
  end

  describe '(scopes)' do
    it 'returns all bookings in date range' do
      bookings = room.bookings.create([{ start_date: Time.now,
                                         end_date: 3.days.from_now,
                                         user: user },
                                       { start_date: 3.days.from_now,
                                         end_date: 5.days.from_now,
                                         user: user },
                                       { start_date: 5.days.from_now,
                                         end_date: 7.days.from_now,
                                         user: user }])
      expect(Booking.filter_by_date_range(2.days.from_now, 4.days.from_now).size).to eq(2)
    end
  end
end
