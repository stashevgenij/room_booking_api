require 'rails_helper'

RSpec.describe 'Bookings API', type: :request do
  let(:room) { create :room }
  let(:user) { create :user }

  describe 'GET /room/:room_id/bookings' do
    let(:booking) { create_list(:booking, 10, room: room, user: user) }

    context 'all bookings' do
      before { get "/bookings/#{room.id}/bookings" }

      it 'returns all rooms' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'bookings in daterange' do
      before { get "/room/#{room.id}/bookings" params: { from: Time.now.to_date, to: 2.days.ago } }

      it 'returns bookings in daterange' do
        expect(json).not_to be_empty
        expect(json.size).to eq(3)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

  end

  describe 'POST /room/:room_id/bookings' do
    let(:valid_attributes) { attributes_for :booking, room: room }

    context 'when not authorized' do
      before { post "/room/#{room.id}/bookings", params: valid_attributes }

      it 'does not create booking' do
        expect(Booking.count).to eq(0)
      end

      it 'returns status code 401'
        expect(response).to have_http_status(401)
      end
    end

    context 'when authorized' do
      before { sign_in user }

      context 'when the request is invalid' do
        before { post "/room/#{room.id}/bookings", params: {} }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: start_date by can't be blank/)
        end
      end

      context 'when the request is valid' do
        before { post '/bookings', params: valid_attributes }

        it 'creates a booking' do
          expect(json['start_date']).to eq(valid_attributes[:start_date])
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

    end
  end
end