require_relative './concerns/bookable'

class Booking < ActiveRecord::Base
    include Bookable
    belongs_to :zone
    belongs_to :user
    
    def self.search(search_for)
        Booking.where("id = ?", search_for)
    end
    
    #def calculate_cost
     #   cost = 100
      #  duration = validate_duration
       # if duration
        #    self.cost = cost * duration
        #end
    #end
    
end
