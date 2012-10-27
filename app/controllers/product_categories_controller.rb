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
    @main_column = ((@page.main_column_id.blank? or Column.find_by_id(@page.main_column_id).blank?) ? Column.first(:conditions => {:title => "Default", :column_location => "main_column"}) : Column.find(@page.main_column_id))
    @main_column_sections = ColumnSection.all(:conditions => {:column_id => @main_column.id, :visible => true, :column_section_id => nil})
    @productcategories = ProductCategory.all(:conditions => {:parent_id => nil})
    @side_column_sections = ColumnSection.all(:conditions => {:column_id => @cms_config['site_settings']['products_side_column_id'], :visible => true}) if @cms_config['site_settings']['products_side_column_id']
  end
  
  def build_tree(current_product_category)
    @product_category_tmp << current_product_category
    unless current_product_category.parent_id == nil
      parent_product_category = ProductCategory.find_by_id(current_product_category.parent_id)
      build_tree(parent_product_category)
    end
  end
end
