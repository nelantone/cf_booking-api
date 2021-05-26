# frozen_string_literal: true

class Booking < ApplicationRecord
  # model association
  belongs_to :mentor

  # validation
  validates :date_time, :call_reason, presence: true
  validate :free_time_frame?

  private

  # To be sure that `date_time` is free, unique and we can update the existing one
  def free_time_frame?
    started_booking_time = Booking.where(date_time: date_time)

    if started_booking_time.present? && (started_booking_time.ids.first != id)
      errors.add(:date_time, 'Sorry, this hour is already booked')
    end
  end
end
