class Admin::RetailersController < AdminController
  before_filter :find_retailer, :only => [ :edit, :update, :destroy ]
  before_filter :find_products, :only => [:new, :edit, :update ]

  def index
    if params[:q].blank?
      all_retailers = Retailer.all
    else
      all_retailers = Retailer.find(:all, :conditions => ["name like ?", "%#{params[:q]}%"])
    end
    @retailers = all_retailers.paginate(:page => params[:page], :per_page => 50)
  end

  def new
    @retailer = Retailer.new
  end

  def edit
  end
  
  def create
    @retailer = Retailer.new(params[:retailer])
    if @retailer.save
      flash[:notice] = "#{@retailer.name} created."
      redirect_to admin_retailers_path
    else
      render :action => "new"
    end
  end
  
  def update
    if @retailer.update_attributes(params[:retailer])
      flash[:notice] = "#{@retailer.name} updated."
      redirect_to admin_retailers_path
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @retailer.destroy
    respond_to :js
  end
  
  private
  
  def find_retailer
    @retailer = Retailer.find params[:id]
  end
  
  def find_products
    @products = Product.find(:all)
  end
  
end
