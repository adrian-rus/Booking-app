require 'booking_decorator'
require 'my_logger'
class BookingsController < ApplicationController
  
  before_filter :authenticate_user!
  
  respond_to :html, :xml, :json
  before_action :find_zone
  
  def index
    @bookings = Booking.where('zone_id = ? AND end_time >= ?', @zone.id, Time.now).order(:start_time) #ensure old bookings are not displayed
    if params[:search]
      @bookings = Booking.search(params[:search])
      @bookings = @bookings.order("start_time ASC")
    else
      @bookings = @bookings.order("start_time DESC")
    end
  end

  def new
    @booking = Booking.new(zone_id: @zone.id)
  end

  def create
    @booking = Booking.new(params[:booking].permit(:zone_id, :start_time, :duration, :user_id))
    @booking.zone = @zone
    @booking.user_id = current_user.id
    @booking.duration = params[:booking][:duration]
    
    myBooking = BasicBooking.new(1, 100)
    
    if params[:booking][:biggroup].to_s.length> 0 then
      myBooking = BigGroupDecorator.new(myBooking)
    end
    
    if params[:booking][:vip].to_s.length> 0 then
      myBooking = VIPDecorator.new(myBooking)
    end
    
    if params[:booking][:extravr].to_s.length> 0 then
      myBooking = ExtraVRDecorator.new(myBooking)
    end
    
    @booking.cost = (@booking.duration - 1)*100 + myBooking.cost
    @booking.description = myBooking.details
    
    if @booking.save
      redirect_to zone_bookings_path(@zone, method: :get)
    else
      render 'new'
    end
    
    logger = MyLogger.instance
    logger.logInformation("A new booking with id "+@booking.id.to_s + 
    " has been created for: " + @booking.start_time.to_s + " for " +
    @booking.duration.to_s + " hours." + "The user id is " + @booking.user_id.to_s) 
    
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def destroy
    @booking = Booking.find(params[:id]).destroy
    if @booking.destroy
      flash[:notice] = "Booking: #{@booking.start_time.strftime('%e %b %Y %H:%M%p')} to #{@booking.end_time.strftime('%e %b %Y %H:%M%p')} deleted"
      redirect_to zone_bookings_path(@zone)
    else
      render 'index'
    end
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    
    @booking.duration = params[:booking][:duration]
    
    myBooking = BasicBooking.new(1, 100)
   
    if params[:booking][:biggroup].to_s.length> 0 then
      myBooking = BigGroupDecorator.new(myBooking)
    end
    
    if params[:booking][:vip].to_s.length> 0 then
      myBooking = VIPDecorator.new(myBooking)
    end
    
    if params[:booking][:extravr].to_s.length> 0 then
      myBooking = ExtraVRDecorator.new(myBooking)
    end
    
    @booking.cost = (@booking.duration - 1)*100 + myBooking.cost
    @booking.description = myBooking.details
    
    updated_information = {
      'start_time' => @booking.start_time,
      'cost' => @booking.cost,
      'description' => @booking.description,
      'duration' => @booking.duration
    }
  
    if @booking.update(updated_information)
      flash[:notice] = 'Your booking was updated succesfully'

      if request.xhr?
        render json: {status: :success}.to_json
      else
        redirect_to zone_bookings_path(@zone)
      end
    else
      render 'edit'
    end
  end

  private

  def save booking
    if @booking.save
        flash[:notice] = 'booking added'
        redirect_to zone_booking_path(@zone, @booking)
      else
        render 'new'
    end
  end

  def find_zone
    if params[:zone_id]
      @zone = Zone.find_by_id(params[:zone_id])
    end
  end

end
