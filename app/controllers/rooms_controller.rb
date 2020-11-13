class RoomsController < ApplicationController
  def index
    @rooms = Room.all
    json_response(@rooms)
  end
end
