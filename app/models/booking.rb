require_relative './concerns/bookable'

class Booking < ActiveRecord::Base
    include Bookable
    belongs_to :zone
    belongs_to :user
    
    def self.search(search_for)
        Booking.where("lower(name) = ?", search_for.downcase)
    end
end
