# frozen_string_literal: true

class Mentor < ApplicationRecord
  # model association
  has_many :bookings, dependent: :destroy

  # validations
  validates :name, :time_zone, presence: true
end
