class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration
      t.text :description
      t.decimal :cost
      t.belongs_to :zone, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
