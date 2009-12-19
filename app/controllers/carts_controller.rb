class CartsController < ApplicationController
  before_filter :find_page
  def show
    @menu_selected = "products"
    @cart = session[:cart]
    @cart_items = @cart.items
  end
  
  def destroy
    session[:cart] = nil
    flash[:notice] = "Your cart has been emptied."
    redirect_to products_path
  end  

 private
  
  def find_page
    @footer_pages = Page.find(:all, :conditions => {:show_in_footer => true}, :order => :footer_pos )
    @page = Page.find_by_permalink!('store')
  end


end
