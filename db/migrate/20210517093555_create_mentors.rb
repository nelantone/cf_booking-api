# frozen_string_literal: true

class CreateMentors < ActiveRecord::Migration[6.1]
  def change
    create_table :mentors do |t|
      t.string :name
      t.string :time_zone

      t.timestamps
    end
  end
end
