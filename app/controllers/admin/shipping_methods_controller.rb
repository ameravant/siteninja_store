class Admin::ShippingMethodsController < AdminController
  before_filter :get_shipping_method, :only => [ :edit, :update, :destroy ]
  
  def index
    @shipping_methods = ShippingMethod.active
  end
  
  def new
    @shipping_method = ShippingMethod.new
  end
  
  def create
    @shipping_method = ShippingMethod.new(params[:shipping_method])
    if @shipping_method.save
      flash[:notice] = "#{@shipping_method.name} added."
      redirect_to admin_shipping_methods_path
    else
      render :action => "new"
    end
  end
  
  def edit
  end
  
  def update
    if @shipping_method.update_attributes(params[:shipping_method])
      flash[:notice] = "#{@shipping_method.name} updated."
      redirect_to admin_shipping_methods_path
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @shipping_method.update_attributes(:deleted => true)
    respond_to :js
  end
  
  private
  
    def get_shipping_method
      begin
        @shipping_method = ShippingMethod.find params[:id]
      rescue
        flash[:error] = "That shipping method could not be found."
        redirect_to admin_shipping_methods_path        
      end
    end
  
end
