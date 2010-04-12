class Product < ActiveRecord::Base
  has_many :images, :as => :viewable, :dependent => :destroy
  has_many :testimonials,  :as => :quotable, :dependent => :destroy
  has_many :features, :as => :featurable, :dependent => :destroy
  has_many :product_options
  has_and_belongs_to_many :related_products, :class_name => "Product", :join_table => "related_products", :foreign_key => "main_product_id", :association_foreign_key => "related_product_id"
	has_and_belongs_to_many :product_categories
  has_permalink :name
  validates_presence_of :name
  validates_numericality_of :price, :sale_price, :allow_blank => true
  default_scope :order => "position"
  after_save :expire_cache
  
  def self.all_cached
    if ENV['RAILS_ENV'] == 'production'
      Rails.cache.fetch("Product.all", :expires_in => 1.week) {
        find :all, :order => "position", :include => :images
      }
    else
      find :all, :order => "position", :include => :images
    end
  end
  
  def real_price
    unless self.price.blank?
      self.sale_price.blank? ? self.price : self.sale_price
    end
  end
  
  def title
    self.name 
  end

  def all
    find :all, :order => "name", :conditions => { :deleted => false }
  end
  
  def to_param
    "#{self.id}-#{self.permalink}"
  end
  

  private    
  
    def expire_cache
      Rails.cache.delete("Product.all")
    end
  
end
