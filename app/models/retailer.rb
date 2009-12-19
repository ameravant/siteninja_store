class Retailer < ActiveRecord::Base
	has_many :stores
	has_permalink :name
	named_scope :featured, :conditions => {:featured => true}
	
  has_attached_file :logo, :styles => { 
    :thumb => "100x50>", 
    :tiny => "99x99#", 
    :small => "180x9999>", 
    :medium => "400x9999>", 
    :large => "800x9999>" 
    }  

	def to_param
    "#{self.id}-#{self.permalink}"
  end
end
