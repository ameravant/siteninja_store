class ProductsController < ApplicationController
  unloadable
  add_breadcrumb 'Home', 'root_path'

	before_filter :find_page

  def index
    @products = Product.find (:all, :conditions => {:active => true, :featured => true})
    @heading = "Product"
    add_breadcrumb 'Product'
  end

  def show
    begin
      @menu_selected = "products"
      @product = Product.find params[:id], :conditions => { :active => true, :deleted => false }
      @heading = @product.name
      @testimonial = Testimonial.find(:all, :conditions => ["quotable_id = ?" , @product.id]).sort_by(&:rand).first #Select a random testimonial
      add_breadcrumb 'Products', 'products_path'
      if @product.product_categories.any?
        @productcategory = @product.product_categories.first
        @product_category_tmp = []
        build_tree(@productcategory)
        for product_category in @product_category_tmp.reverse
          add_breadcrumb product_category.title, product_category_path(product_category)
        end
			end
			if @product.product_options
			  product_prices = []
		    @product.product_options.each do |po|
		      product_prices << [po.id,po.price,po.sale_price]
		    end 
        @product_price_string = ""
        product_prices.each_with_index do |p, index|
          @product_price_string += "[#{p.join(",")}]#{product_prices.length != index + 1 ? "," : ""}"
        end
		  end
			add_breadcrumb @product.name
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "The product you were looking for was not found."
      redirect_to products_path
    end
  end

  def add_to_cart
    begin
      @product = Product.find params[:id], :conditions => { :active => true, :deleted => false }
      find_cart.add_product(@product, 1)
      redirect_to cart_path
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "That product is not available."
      redirect_to products_path
    end
  end

  private

  def find_page
    @footer_pages = Page.find(:all, :conditions => {:show_in_footer => true}, :order => :footer_pos )
    @page = Page.find_by_permalink!('products')
    @productcategories = ProductCategory.all
    @topproductcategories = ProductCategory.all(:conditions => {:parent_id => nil})
    # @product_category_tmp = []
    #     build_tree(@product_category)
    #     for product_category in @product_category_tmp.reverse
    #       unless product_category == @product_category
    #         add_breadcrumb product_category.title, product_category_path(product_category)
    #       else  
    #         add_breadcrumb product_category.title
    #       end
    #     end
  end

  def find_cart
    session[:cart] ||= Cart.new
  end

  def build_tree(current_product_category)
    @product_category_tmp << current_product_category
    unless current_product_category.parent_id == nil
      parent_product_category = ProductCategory.find_by_id(current_product_category.parent_id)
      build_tree(parent_product_category)
    end
  end

end

