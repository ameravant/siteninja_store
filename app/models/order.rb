class Order < ActiveRecord::Base
  serialize :response
  has_many :order_items
  has_one :shipping_address
  has_one :billing_address
  belongs_to :shipping_method
end
