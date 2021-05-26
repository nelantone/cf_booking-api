# frozen_string_literal: true

# rename to date_time a more descriptive name * Be aware of endpoint changes
class RenameColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :bookings, :date_time, :start_time
  end
end
