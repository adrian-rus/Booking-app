require 'my_logger'
class BookingsController < ApplicationController
  
  before_filter :authenticate_user!
  
  respond_to :html, :xml, :json
  before_action :find_zone
  
  def index
    @bookings = Booking.where("zone_id = ? AND end_time >= ?", @zone.id, Time.now).order(:start_time)
    respond_with @bookings
    if params[:search]
      @bookings = Booking.search(params[:search])
      @bookings = @bookings.order("created_at ASC")
    else
      @bookings = @bookings.order("created_at DESC")
    end
  end

  def new
    @booking = Booking.new(zone_id: @zone.id)
  end

  def create
    @booking =  Booking.new(params[:booking].permit(:zone_id, :start_time, :duration))
    @booking.zone = @zone
    if @booking.save
      redirect_to zone_bookings_path(@zone, method: :get)
    else
      render 'new'
    end
    
    logger = MyLogger.instance
    logger.logInformation("A new booking has been created on: " + @booking.start_time.to_s + " for " + @booking.duration.to_s + " hours.") 
    
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
    # @booking.zone = @zone

    if @booking.update(params[:booking].permit(:zone_id, :start_time, :duration))
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
  
=begin
  def userbookings
    user = User.find_by_user_id(current_user.id)
    if user.booking_id.nil?
      redirect_to "/zones/"
    else
      @user = User.find_by_user_id(current_user.id)
      redirect_to zone_bookings_path(@zone)
    end
=end

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
