# frozen_string_literal: true

class Booking < ApplicationRecord
  # model association
  belongs_to :mentor

  # validation
  validates :date_time, :call_reason, presence: true
end
