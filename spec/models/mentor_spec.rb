require 'rails_helper'

RSpec.describe Mentor, type: :model do
  # Association test
  # ensure `Mentor` model has a `1:m` relationship with the `Booking` model
  it { should have_many(:bookings).dependent(:destroy) }
  # Validation tests
  # ensure columns `name` and `time_zone` are present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:time_zone) }
end
