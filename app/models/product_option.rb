class ProductOption < ActiveRecord::Base
  belongs_to :product
  attr_accessor :delete
  # before_save :check_prices
  # 
  # def check_prices
  #   if self.sale_price and self.price.blank?
  #     errors.add_to_base("You must provide a price to have a sale price")
  #   end
  # end

end