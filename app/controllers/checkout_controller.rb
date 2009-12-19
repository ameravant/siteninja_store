class CheckoutController < ApplicationController
  # ssl_required :new, :create
  before_filter :set_checkout
  before_filter :find_page
  
  private
  
  def set_checkout
    @checkout = true
  end
  
  def find_page
    @footer_pages = Page.find(:all, :conditions => {:show_in_footer => true}, :order => :footer_pos )
    @page = Page.find_by_permalink!('store')
  end
end
