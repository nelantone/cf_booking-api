# frozen_string_literal: true

class Mentor < ApplicationRecord
  # model association
  has_many :bookings, dependent: :destroy

  # validations
  validates_presence_of :name, :time_zone
end
