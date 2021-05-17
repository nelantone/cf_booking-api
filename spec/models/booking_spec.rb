# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Booking, type: :model do
  # Association test
  # ensure an booking record belongs to a single mentor record
  it { should belong_to(:mentor) }
  # Validation test
  # ensure column name, date_time, call_reason is present before saving
  it { should validate_presence_of(:date_time) }
  it { should validate_presence_of(:call_reason) }
end
