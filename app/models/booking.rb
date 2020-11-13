class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates_presence_of :start_date, :end_date
  validate :start_date_earlier_that_end_date, :start_date_is_today_or_later, :room_is_free_for_dates

  scope :filter_by_date_range, ->(from, to) { where('start_date <= ? AND end_date > ?', to, from) }

  def self.create_multiple(params)
    if params.is_a?(Array)

      # rollback if at least one invalid
      # отменяем все брони если хотя бы одна не прошла валидацию,
      # т.к. вероятнее всего клиент не захочет бронировать частично)
      transaction do
        params.map do |booking_params|
          booking = new(booking_params)
          booking.save! ? booking : raise(ActiveRecord::Rollback)
        end
      end

    else
      create!(params)
    end
  end

  private

  def start_date_earlier_that_end_date
    errors.add(:start_date, 'should be earlier than end date') if start_date && end_date && start_date > end_date
  end

  def start_date_is_today_or_later
    errors.add(:start_date, 'should be today or later') if start_date && start_date < Time.now.to_date
  end

  def room_is_free_for_dates
    if room && start_date && end_date && room.bookings.filter_by_date_range(start_date, end_date).any?
      errors.add(:room, 'is already booked on these dates')
    end
  end
end
