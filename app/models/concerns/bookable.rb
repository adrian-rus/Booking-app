module Bookable
  extend ActiveSupport::Concern

  included do
    belongs_to :zone

    validates :start_time, presence: true 
    validates :duration, presence: true, numericality: { greater_than: 0 }
    validate :start_date_cannot_be_in_the_past
    validate :overlaps

    before_validation :calculate_end_time
  

    scope :end_during, ->(new_start_time, new_end_time) do
      if (!new_start_time.nil?) && (!new_end_time.nil?)
        where('end_time > ? AND end_time < ?', new_start_time, new_end_time)
      else
        return nil
      end
    end

    scope :start_during, ->(new_start_time, new_end_time) do
      if (!new_start_time.nil?) && (!new_end_time.nil?)
        where('start_time > ? AND start_time < ?', new_start_time, new_end_time)
      else
        return nil
      end
    end

    scope :happening_during, ->(new_start_time, new_end_time) do
      if (!new_start_time.nil?) && (!new_end_time.nil?)
        where('start_time > ? AND end_time < ?', new_start_time, new_end_time)
      else
        return nil
      end 
    end

    scope :enveloping, ->(new_start_time, new_end_time) do
      if (!new_start_time.nil?) && (!new_end_time.nil?)
        where('start_time < ? AND end_time > ?', new_start_time, new_end_time)
      else
        return nil
      end
    end

    scope :identical, ->(new_start_time, new_end_time) do
      if (!new_start_time.nil?) && (!new_end_time.nil?)
        where('start_time = ? AND end_time = ?', new_start_time, new_end_time)
      else
        return nil
      end
    end
  end

  def overlaps
    overlapping_bookings = [ 
      zone.bookings.end_during(start_time, end_time),
      zone.bookings.start_during(start_time, end_time),
      zone.bookings.happening_during(start_time, end_time),
      zone.bookings.enveloping(start_time, end_time),
      zone.bookings.identical(start_time, end_time)
    ].flatten

    overlapping_bookings.delete self
    if overlapping_bookings.any?
      errors.add(:base, 'Slot has already been booked')
    end
  end

  def start_date_cannot_be_in_the_past
    if start_time && start_time < DateTime.now + (15.minutes)
      errors.add(:start_time, 'must be at least 15 minutes from present time')
    end
  end

  def calculate_end_time
    start_time = validate_start_time
    duration = validate_duration
    if start_time && duration
      self.end_time = start_time + (duration.hours - 60)
    end
  end
  
  def calculate_cost
    cost = 100
    duration = validate_duration
    if duration
      self.cost = cost * duration
    end
  end

  def as_json(options = {})  
   {  
    :id => self.id,  
    :start => self.start_time,  
    :end => self.end_time + 60,  
    :recurring => false, 
    :allDay => false
   }  
  end  

  private

    def validate_start_time
      if !self.start_time.nil?
        start_time = self.start_time
      else
        return nil
      end
    end

    def validate_duration
      if !self.duration.nil?
        duration = self.duration.to_i
      else
        return nil
      end
    end

end