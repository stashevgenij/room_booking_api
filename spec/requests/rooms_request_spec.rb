require 'rails_helper'

RSpec.describe 'Rooms API', type: :request do
  let!(:rooms) { create_list(:room, 10) }

  describe 'GET /rooms' do
    before { get '/rooms' }

    it 'returns rooms' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end