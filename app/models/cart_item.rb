class CartItem

  attr_reader :id, :name, :permalink, :price, :sale_price, :real_price, :quantity

  def initialize(product, quantity=1)
    @id = product.id
    @name = product.name
    @permalink = product.permalink
    @quantity = quantity
    @price = product.price
    @sale_price = product.sale_price
    @real_price = product.real_price
  end

  def increment_quantity
    @quantity += 1
  end

  def set_quantity(quantity)
    @quantity = quantity.to_i
  end
  
  def total
    @real_price * @quantity
  end

end