require 'rails_helper'

RSpec.describe 'bookings API' do
  # Initialize the test data
  let!(:mentor)   { create(:mentor) }
  let!(:bookings) { create_list(:booking, 5, mentor_id: mentor.id) }
  let(:mentor_id) { mentor.id }
  let(:id)        { bookings.first.id }

  # Test suite for GET /mentors/:mentor_id/bookings
  describe 'GET /mentors/:mentor_id/bookings' do
    before { get "/mentors/#{mentor_id}/bookings" }

    context 'when mentor exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all mentor bookings' do
        expect(json.size).to eq(5)
      end
    end

    context 'when mentor does not exist' do
      let(:mentor_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Mentor/)
      end
    end
  end

  # Test suite for GET /mentors/:mentor_id/bookings/:id
  describe 'GET /mentors/:mentor_id/bookings/:id' do
    before { get "/mentors/#{mentor_id}/bookings/#{id}" }

    context 'when mentor booking exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the booking' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when mentor booking does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Booking/)
      end
    end
  end

  # Test suite for PUT /mentors/:mentor_id/bookings
  describe 'POST /mentors/:mentor_id/bookings' do
    let(:valid_attributes) do
      { date_time: DateTime.new(2021, 2, 3, 4, 5, 6),
        call_reason: 'Say hi!' }
    end

    context 'when request attributes are valid' do
      before { post "/mentors/#{mentor_id}/bookings", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when an invalid request' do
      before { post "/mentors/#{mentor_id}/bookings", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Date time can't be blank/)
      end
    end
  end

  # Test suite for PUT /mentors/:mentor_id/bookings/:id
  describe 'PUT /mentors/:mentor_id/bookings/:id' do
    let(:valid_attributes) { { call_reason: 'Say bye!' } }

    before { put "/mentors/#{mentor_id}/bookings/#{id}", params: valid_attributes }

    context 'when booking exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end

      it 'updates the booking' do
        updated_booking = Booking.find(id)
        expect(updated_booking.call_reason).to match(/Say bye!/)
      end
    end

    context 'when the booking does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Booking/)
      end
    end
  end

  # Test suite for DELETE /mentors/:id
  describe 'DELETE /mentors/:id' do
    before { delete "/mentors/#{mentor_id}/bookings/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
