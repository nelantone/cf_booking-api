# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.datetime :start_time
      t.string :call_reason
      t.references :mentor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
