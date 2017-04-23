require_relative './concerns/bookable'

class Booking < ActiveRecord::Base
    include Bookable
    belongs_to :zone
end
