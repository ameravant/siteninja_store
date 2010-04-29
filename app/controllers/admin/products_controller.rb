class Admin::ProductsController < AdminController
  unloadable
  before_filter :find_product, :only => [ :edit, :update, :show, :destroy, :reorder ]
  before_filter :find_categories, :only => [ :edit, :new, :update ]
  add_breadcrumb "Products", nil

  def index
    @products = Product.all.paginate(:page => params[:page], :per_page => 25)
  end

  def new
    @product = Product.new
    @product.product_options.build
    @products = Product.find(:all, :conditions => ["id != ?", @product.id])
  end
  
  def show
    @images = @product.images
  end

  def edit
    @products = Product.find(:all, :conditions => ["id != ?", @product.id])
  end
  
  def destroy
    @product.destroy
    respond_to :js
  end
  
  def reorder
    params["images"].each_with_index do |id, position|
      @product.update_attributes(:main_image_id => id) if position == 0
      Image.update(id, :position => position + 1)
    end
    render :nothing => true
  end
  
  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = "#{@product.name} created."
      redirect_to admin_products_path
    else
      render :action => "new"
    end
  end
  
  def update
    params[:product][:existing_product_options] ||= {}
    if @product.update_attributes(params[:product])
      flash[:notice] = "#{@product.name} updated."
      redirect_to admin_products_path
    else
      @products = Product.find(:all, :conditions => ["id != ?", @product.id])
      render :action => "edit"
    end
  end
  
  private
  
  def find_product
    @product = Product.find params[:id]
  end
  
  def find_categories  
    @product_categories = ProductCategory.all
  end
  
end
