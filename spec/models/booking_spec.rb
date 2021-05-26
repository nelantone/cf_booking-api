# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Booking, type: :model do
  # Association test
  # ensure an booking record belongs to a single mentor record
  # Initialize the test data
  let!(:mentor) { create(:mentor) }

  it { should belong_to(:mentor) }
  # Validation test
  # ensure column name, start_time, call_reason is present before saving
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:call_reason) }

  describe '#free_time_frame?' do
    context 'when the time slot is free' do
      it 'is valid' do
        expect(build(:booking, mentor_id: mentor.id)).to be_valid
      end
    end

    context 'when there is an overlap' do
      let(:booking_start_time) { Time.zone.now.beginning_of_hour }

      before { create(:booking, mentor_id: mentor.id, start_time: booking_start_time) }

      it 'is invalid' do
        expect(build(:booking, mentor_id: mentor.id, start_time: booking_start_time)).to be_invalid
      end

      it 'raises an invalid error' do
        expect do
          create(:booking, mentor_id: mentor.id,
                           start_time: booking_start_time)
        end.to raise_error(/Sorry, this hour is already booked/)
      end
    end
  end
end
