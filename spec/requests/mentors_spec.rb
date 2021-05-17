require 'rails_helper'

RSpec.describe 'mentors API', type: :request do
  # initialize test data
  let!(:mentors) { create_list(:mentor, 2) }
  let(:mentor_id) { mentors.first.id }

  # Test suite for GET /mentors
  describe 'GET /mentors' do
    # make HTTP get request before each example
    before { get '/mentors' }

    it 'returns mentors' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for GET /mentors/:id
  describe 'GET /mentors/:id' do
    before { get "/mentors/#{mentor_id}" }

    context 'when the record exists' do
      it 'returns the mentor' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(mentor_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the record does not exist' do
      let(:mentor_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Mentor/)
      end
    end
  end

  # Test suite for POST /mentors
  describe 'POST /mentors' do
    # valid payload
    let(:valid_attributes) { { name: 'Mr. Jones', time_zone: 'Germany/Berlin' } }

    context 'when the request is valid' do
      before { post '/mentors', params: valid_attributes }

      it 'creates a mentor' do
        expect(json['name']).to eq('Mr. Jones')
        expect(json['time_zone']).to eq('Germany/Berlin')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      before { post '/mentors', params: { name: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Time zone can't be blank/)
      end
    end
  end

  # Test suite for PUT /mentors/:id
  describe 'PUT /mentors/:id' do
    let(:valid_attributes) { { name: 'Something', time_zone: 'Mexico/Mexico' } }

    context 'when the record exists' do
      before { put "/mentors/#{mentor_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  # Test suite for DELETE /mentors/:id
  describe 'DELETE /mentors/:id' do
    before { delete "/mentors/#{mentor_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
