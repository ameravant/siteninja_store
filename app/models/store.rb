class Store < ActiveRecord::Base
  belongs_to :retailer
  has_and_belongs_to_many :products
  validates_presence_of :name, :address, :city, :state, :zip, :phone
  default_scope :order => "state, city, stores.name"
  
  def location
    "#{self.city}, #{self.state}"
  end
end
