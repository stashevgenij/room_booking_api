class BookingsController < ApplicationController
  before_action :auth_user, only: [:create]
  before_action :set_room

  def index
    if params[:from] && params[:to]
      @bookings = @room.bookings.filter_by_date_range(params[:from], params[:to])
    else
      @bookings = Booking.all
    end
    json_response(@bookings)
  end

  def create
    @bookings = Booking.create_multiple(merged_booking_params)
    json_response(@bookings, :created)
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def booking_params
    params.permit(:room_id, bookings: [:start_date, :end_date])
  end

  def merged_booking_params
    booking_params[:bookings].map { |b| b.merge({ room: @room, user: current_user })}
  end
end
