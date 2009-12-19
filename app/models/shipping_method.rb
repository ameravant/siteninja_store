class ShippingMethod < ActiveRecord::Base
  validates_presence_of :name, :price
  validates_numericality_of :price, :allow_blank => true
  belongs_to :order
  
  named_scope :active, :conditions => { :deleted => false }, :order => "price"
end