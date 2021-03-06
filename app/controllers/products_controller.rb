class ProductsController < ApplicationController
  unloadable
  add_breadcrumb 'Home', 'root_path'

	before_filter :find_page

  def index
    @products = Product.find(:all, :conditions => {:active => true, :featured => true})
    @heading = "Product"
    add_breadcrumb 'Product'
  end

  def show
    begin
      @menu_selected = "products"
      @product = Product.find params[:id], :conditions => { :active => true, :deleted => false }
      @heading = @product.name
      @main_column = (@tmplate.product_layout_id ? Column.find(@tmplate.product_layout_id) : Column.first(:conditions => {:column_location => "product"}))
      @main_column_sections = ColumnSection.all(:conditions => {:column_id => @main_column.id, :visible => true, :column_section_id => nil})
      add_breadcrumb 'Products', 'products_path'
      if @product.product_categories.any?
        @productcategory = @product.product_categories.first
        @product_category_tmp = []
        build_tree(@productcategory)
        for product_category in @product_category_tmp.reverse
          begin
            add_breadcrumb product_category.title, product_category_path(product_category)  
          rescue Exception => e
            
          end
          
          
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
    @body_class = "store-body"
    @main_column = ((@page.main_column_id.blank? or Column.find_by_id(@page.main_column_id).blank?) ? Column.first(:conditions => {:title => "Default", :column_location => "main_column"}) : Column.find(@page.main_column_id))
    @main_column_sections = ColumnSection.all(:conditions => {:column_id => @main_column.id, :visible => true, :column_section_id => nil})
    @productcategories = ProductCategory.all
    @topproductcategories = ProductCategory.all(:conditions => {:parent_id => nil})
    @side_column_sections = ColumnSection.all(:conditions => {:column_id => @cms_config['site_settings']['products_side_column_id'], :visible => true}) if @cms_config['site_settings']['products_side_column_id']
    
      
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

