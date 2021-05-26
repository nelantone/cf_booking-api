# frozen_string_literal: true

class Booking < ApplicationRecord
  # model association
  belongs_to :mentor

  # validation
  validates :start_time, :call_reason, presence: true
  validate :free_time_frame?

  private

  # To be sure that `start_time` is free, unique and we can update the existing one
  def free_time_frame?
    started_booking_time = Booking.where(start_time: start_time)

    if started_booking_time.present? && (started_booking_time.ids.first != id)
      errors.add(:start_time, 'Sorry, this hour is already booked')
    end
  end
end
