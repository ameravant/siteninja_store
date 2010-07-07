class ProductCategoriesController < ApplicationController
  unloadable
  add_breadcrumb 'Home', 'root_path'
  add_breadcrumb 'Products', 'products_path'
  before_filter :find_page
  
  def show
    begin
      @productcategories = ProductCategory.all
      @topproductcategories = ProductCategory.all(:conditions => {:parent_id => nil})
      @productcategory = ProductCategory.find(params[:id])
      @products = @productcategory.products.reject{|p| p.active == false }
      @product_category_tmp = []
      build_tree(@productcategory)
      for product_category in @product_category_tmp.reverse
        unless product_category == @productcategory
          add_breadcrumb product_category.title, product_category_path(product_category)
        else  
          add_breadcrumb product_category.title
        end
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to '/404.html'
    end
  end

  private
  
  def find_page
    @footer_pages = Page.find(:all, :conditions => {:show_in_footer => true}, :order => :footer_pos )
    @page = Page.find_by_permalink!('products')
    @productcategories = ProductCategory.all(:conditions => {:parent_id => nil})
  end
  
  def build_tree(current_product_category)
    @product_category_tmp << current_product_category
    unless current_product_category.parent_id == nil
      parent_product_category = ProductCategory.find_by_id(current_product_category.parent_id)
      build_tree(parent_product_category)
    end
  end
end
