class Product < ActiveRecord::Base
  acts_as_taggable
  has_many :images, :as => :viewable, :dependent => :destroy
  has_many :testimonials,  :as => :quotable, :dependent => :destroy
  has_many :features, :as => :featurable, :dependent => :destroy
  has_many :product_options, :dependent => :destroy
  has_and_belongs_to_many :related_products, :class_name => "Product", :join_table => "related_products", :foreign_key => "main_product_id", :association_foreign_key => "related_product_id"
	has_and_belongs_to_many :product_categories
  has_permalink :title
  validates_presence_of :title
  default_scope :order => "position"
  after_save :expire_cache
  accepts_nested_attributes_for :images
  
  validates_associated :product_options

   after_update :save_product_options
   
   #Product options are checked for the delete option being set to true to destroy record
   def existing_product_options=(product_options)     
     product_options.each do |key, option|
       if option[:delete] == "true"
         self.product_options.find(key).destroy
       else
         self.product_options.find(key).update_attributes(option)
       end
     end
   end
   
   def new_product_options=(product_options)
     product_options.each do |option|
       if  option[:delete] == "false"
         self.product_options.build(option)
       end
     end
   end

   def save_product_options
     product_options.each do |option|
       option.save(false)
     end
   end
  
  def self.all_cached
    if ENV['RAILS_ENV'] == 'production'
      Rails.cache.fetch("Product.all", :expires_in => 1.week) {
        find :all, :order => "position", :include => :images
      }
    else
      find :all, :order => "position", :include => :images
    end
  end

  def name
    self.title
  end
  
  def all
    find :all, :order => "title", :conditions => { :deleted => false }
  end
  
  def to_param
    "#{self.id}-#{self.permalink}"
  end
  

  private    
  
    def expire_cache
      Rails.cache.delete("Product.all")
    end
  
end
