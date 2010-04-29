class ProductOption < ActiveRecord::Base
  belongs_to :product
  attr_accessor :delete
end