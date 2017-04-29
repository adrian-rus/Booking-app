class Zone < ActiveRecord::Base
    has_many :bookings
    has_many :users, :through => :bookings
end
