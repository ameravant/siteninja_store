class ProductCategory < ActiveRecord::Base
	has_permalink :name
	has_and_belongs_to_many :products
  default_scope :order => "parent_id, position"
	def to_param
    "#{self.id}-#{self.permalink}"
  end
  def title
    self.name
  end
  
  def children
  	ProductCategory.find(:all, :conditions => ["parent_id = ?", self.id])
  end
  
  def parent
    unless self.parent_id.blank?
  	  ProductCategory.find(:first, :conditions => ["id = ?", self.parent_id])
  	else
  	  false
  	end
  end
  

  
end
