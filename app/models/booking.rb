# frozen_string_literal: true

class Booking < ApplicationRecord
   # model association
  belongs_to :mentor

  # validation
  validates_presence_of :date_time, :call_reason
end
