require 'rails_helper'

RSpec.describe 'Bookings API', type: :request do
  let!(:room) { create :room }
  let(:user) { create :user }
  let(:first_room) { Room.first }

  describe 'GET /rooms/:room_id/bookings' do
    let!(:bookings) { create_list(:booking, 10, room: room, user: user) }

    context 'all bookings' do
      before { get "/rooms/#{room.id}/bookings" }

      it 'returns all rooms' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'bookings in daterange' do
      before { get "/rooms/#{room.id}/bookings", params: { from: bookings.first.start_date, to: bookings.third.start_date } }

      it 'returns bookings in daterange' do
        expect(json).not_to be_empty
        expect(json.size).to eq(3)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

  end

  describe 'POST /rooms/:room_id/bookings' do
    let(:valid_attributes)       { attributes_for :booking, room: room }

    context 'when not authorized' do
      before { post "/rooms/#{room.id}/bookings", params: { bookings: [valid_attributes] }, as: :json }

      it 'does not create booking' do
        expect(Booking.count).to eq(0)
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when authorized' do
      let(:headers) { user_headers(user) }

      context 'when the request is invalid' do
        before { post "/rooms/#{room.id}/bookings", params: { bookings: [{}] }, headers: headers, as: :json }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Start date can't be blank, End date can't be blank/)
        end
      end

      context 'when the request is valid' do
        before do 
          post "/rooms/#{room.id}/bookings", params: { bookings: [valid_attributes] }, headers: headers, as: :json
        end

        it 'creates a booking' do
          puts response.body
          expect(json[0]['start_date']).to eq(valid_attributes[:start_date].to_date.to_s)
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

    end
  end
end