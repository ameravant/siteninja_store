class Admin::ProductCategoriesController < AdminController
  before_filter :find_product_categories
  before_filter :get_product_categories
  before_filter :find_product_category, :only => [ :edit, :update, :destroy ]
  before_filter :build_options, :only => [ :edit, :new, :create ]
  
  
  def index
    @product_categories = ProductCategory.find(:all)
  end

  def new
    @product_category = ProductCategory.new
  end

  def edit
  end
  
  def create
    @product_category = ProductCategory.new(params[:product_category])
    if @product_category.save
      flash[:notice] = "#{@product_category.name} created."
      redirect_to admin_product_categories_path
    else
      render :action => "new"
    end
  end
  
  def update
    if @product_category.update_attributes(params[:product_category])
      flash[:notice] = "#{@product_category.name} updated."
      redirect_to admin_product_categories_path
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @product_category.destroy
    respond_to :js
  end
  
  def reorder
    params["tree_#{params[:product_category_id]}"].each_with_index do |id, position|
      ProductCategory.update(id, :position => position + 1)
    end
    render :nothing => true
  end
  
  private
  
  def find_product_category
    @product_category = ProductCategory.find params[:id]
  end
  
  def find_product_categories
    @product_categories = ProductCategory.all
  end
    
  def get_product_categories
    @product_categories = ProductCategory.all
    @options_for_parent_id = []
    @options_for_parent_id_level = 0
  end
  
  def build_options(parent_id=nil)
    children = @product_categories.select { |tree_category| tree_category.parent_id == parent_id }
    @options_for_parent_id_level = @options_for_parent_id_level + 1

    unless children.empty?
      for child in children
        nbsp_string = '&nbsp;' * (@options_for_parent_id_level * @options_for_parent_id_level) unless @options_for_parent_id_level == 1
        @options_for_parent_id << ["#{nbsp_string}#{child.title}", child.id]
        build_options(child.id)
      end
    end
    @options_for_parent_id_level = @options_for_parent_id_level - 1
  end
  
end
