class CartItemsController < ApplicationController
  
  def destroy
    item_name = find_cart.remove_product(params[:id])
    if find_cart.items.empty?
      flash[:notice] = "#{item_name} removed. Your cart is now empty."
      redirect_to products_path
    else
      flash[:notice] = "#{item_name} removed from your cart."
      redirect_to cart_path
    end
  end
  
  def update
    quantity = params[:quantity].to_i
    if quantity > 0
      item_name = find_cart.update_product(params[:id], quantity)
      flash[:notice] = "#{item_name} quantity updated."
    else
      item_name = find_cart.remove_product(params[:id])
      flash[:notice] = "#{item_name} removed from your cart."
    end
    redirect_to cart_path
  end
  
  private

  def find_cart
    session[:cart] ||= Cart.new
  end

end
