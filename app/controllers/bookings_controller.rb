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
    @booking = Booking.create_multiple(booking_params.merge({ room: @room, user: current_user }))
    json_response(@booking, :created)
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def booking_params
    params.permit(:start_date, :end_date)
  end
end
