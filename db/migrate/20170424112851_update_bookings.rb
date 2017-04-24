class UpdateBookings < ActiveRecord::Migration
  def change
    change_table :bookings do |t|
        t.references :user, index: true, foreign_key: true
    end
  end
end
