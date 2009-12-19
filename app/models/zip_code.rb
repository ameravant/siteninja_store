class ZipCode < ActiveRecord::Base
  validates_presence_of :zip, :city, :state, :lat, :long
  
  def location
    "#{self.city}, #{self.state}"
  end
  
  # Returns zip codes within a radius of a given zip code.
  # Radius searched within given miles.
  def self.radius_search(zip_code, radius=15.0)
    begin
      # Constants
      latitude_miles = 69.172
      longitude_miles = (latitude_miles * Math.cos(zip_code.lat.to_f * (Math::PI/180))).abs
      latitude_degrees = radius.to_f / latitude_miles
      longitude_degrees = radius.to_f / longitude_miles
      min_latitude = zip_code.lat.to_f - latitude_degrees
      max_latitude = zip_code.lat.to_f + latitude_degrees
      min_longitude = zip_code.long.to_f - longitude_degrees
      max_longitude = zip_code.long.to_f + longitude_degrees

      # Return array of zip codes found within radius
      ZipCode.find :all, :conditions => { :lat => (min_latitude..max_latitude), :long => (min_longitude..max_longitude) }

    rescue ActiveRecord::RecordNotFound
      # submitted zip code was not found in our database
      nil 
    end                  
  end

end
