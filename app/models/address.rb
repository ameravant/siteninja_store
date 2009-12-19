class Address < ActiveRecord::Base
  belongs_to :location
  belongs_to :order
  validates_presence_of :first_name, :last_name, :street_address, :city, :postal_code
  validates_presence_of :location_id
  validates_numericality_of :location_id, :allow_blank => true
  validates_format_of :email, :with => /\A\S+\@\S+\.\S+\Z/, :allow_blank => true
  
  def name
    o = []
    o << self.first_name
    o << self.last_name
    o.compact.join(' ')
  end
  
  def to_a
    o = []
    o << self.name
    o << self.street_address
    o << self.street_address_2
    o << "#{self.city}, #{self.location.abbreviation} #{self.postal_code}"
    o << self.email
    o.compact.reject(&:blank?)
  end
  
end
