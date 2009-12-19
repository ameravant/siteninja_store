class Location < ActiveRecord::Base
  validates_presence_of :country, :name, :abbreviation
  validates_uniqueness_of :name, :scope => :country
  
  def full_location
    "#{self.country}: #{self.name}"
  end
end
