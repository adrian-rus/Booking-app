# the concrete component we would like to decorate, a booking in our example
class BasicBooking
    def initialize(duration, cost)
        @duration = duration
        @cost = cost
        @description = "Basic booking"
    end
    
    # getter method
    def cost
        return @cost
    end
    
    # getter method
    def duration
        return @duration
    end
    
    # a method which returns a string representation of the object of type BasicBooking
    def details
        return @description + ": " +
        @duration.to_s + " hour for " +
        @cost.to_s + " euros."
    end
end #ends the BasicBooking class

# decorator class -- this serves as the superclass for all the concrete decorators
# the base/super class decorator (i.e. no actual decoration yet), each concrete decorator (i.e. subclass) will add its own decoration
class BookingDecorator < BasicBooking
    
    def initialize(basic_booking)
        #basic_booking is a real booking, i.e. the component we want to decorate
        @basic_booking = basic_booking
        super(@basic_booking.duration, @basic_booking.cost)
        @extra_cost = 0
        @description = " No extras added. "
    end
    
    # override the cost method to include the cost of the extra feature	
    def cost
        return @extra_cost + @basic_booking.cost
    end
    
    # override the details method to include the description of the extra feature
    def details
        return  @description + " Extra cost: " + "#{@extra_cost}" + ". " + @basic_booking.details
    end
    
end # ends the BookingDecorator class

# a concrete decorator --  define an extra feature
class BigGroupDecorator < BookingDecorator
    def initialize(basic_booking)
        super(basic_booking)
        @extra_cost = 200
        @description = "Big group option added."
    end
end #ends BigGroupDecorator class

# a concrete decorator --  define an extra feature
class VIPDecorator < BookingDecorator
    def initialize(basic_booking)
        super(basic_booking)
        @extra_cost = 500
        @description = "VIP option added."
    end
end #ends VIPDecorator class

# a concrete decorator --  define an extra feature
class ExtraVRDecorator < BookingDecorator
    def initialize(basic_booking)
        super(basic_booking)
        @extra_cost = 300
        @description = "Extra VR controllers added."
    end
end # ends ExtraVRDecorator class