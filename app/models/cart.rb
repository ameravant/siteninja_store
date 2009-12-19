class Cart

  attr_reader :items, :shipping_total, :taxes_total
  
  def initialize
    @items = []
    @shipping_total = nil
    @taxes_total = nil
    @billing_state = nil
  end
  
  def add_product(product, quantity=1)
    item_in_cart = @items.find { |item| item.id == product.id }
    if item_in_cart
      item_in_cart.increment_quantity
    else
      @items << CartItem.new(product, quantity)
    end
  end
  
  def update_product(product_id, quantity)
    item_in_cart = @items.find { |item| item.id == product_id.to_i }
    item_in_cart.set_quantity(quantity)
    return item_in_cart.name
  end
  
  def remove_product(product_id)
    item_in_cart = @items.find { |item| item.id == product_id.to_i }
    @items.delete(item_in_cart)
    return item_in_cart.name
  end
  
  def update_taxes_total(taxes_total)
    @taxes_total = taxes_total
  end
    
  def update_shipping_total(shipping_total)
    @shipping_total = shipping_total
  end

  def items_count
    @items.collect(&:quantity).sum
  end

  def subtotal
    @items.collect(&:total).sum
  end

  def total
    self.subtotal + (@shipping_total || 0) + (@taxes_total || 0)
  end
  
  def total_in_cents
    (self.total * 100).to_i
  end
  
end