class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.datetime :date_time
      t.string :call_reason
      t.references :mentor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
