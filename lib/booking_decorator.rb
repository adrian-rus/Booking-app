class BasicBooking
    def initialize(duration, cost)
        @duration = duration
        @cost = cost
        @description = "Basic booking"
    end
    
    def cost
        return @cost
    end
    
    def duration
        return @duration
    end
    
    def details
        return @description + ": " +
        @duration.to_s + " hour for " +
        @cost.to_s + " euros."
    end
end #ends the BasicBooking class

class BookingDecorator < BasicBooking
    
    def initialize(basic_booking)
        @basic_booking = basic_booking
        super(@basic_booking.duration, @basic_booking.cost)
        @extra_cost = 0
        @description = " No extras added. "
    end
    
    def cost
        return @extra_cost + @basic_booking.cost
    end
    
    def details
        return  @description + " Extra cost: " + "#{@extra_cost}" + ". " + @basic_booking.details
    end
    
end # ends the BookingDecorator class

class BigGroupDecorator < BookingDecorator
    def initialize(basic_booking)
        super(basic_booking)
        @extra_cost = 200
        @description = "Big group option added."
    end
end #ends BigGroupDecorator class

class VIPDecorator < BookingDecorator
    def initialize(basic_booking)
        super(basic_booking)
        @extra_cost = 500
        @description = "VIP option added."
    end
end #ends VIPDecorator class

class ExtraVRDecorator < BookingDecorator
    def initialize(basic_booking)
        super(basic_booking)
        @extra_cost = 300
        @description = "Extra VR controllers added."
    end
end # ends ExtraVRDecorator class