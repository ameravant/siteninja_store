class Admin::OrdersController < AdminController
add_breadcrumb "Orders", nil
  def index
    if params[:q].blank?
      @all_orders = Order.find(:all, :include => [ :shipping_address, :billing_address ])
    else
      @all_orders = Order.find(:all, :include => [ :shipping_address, :billing_address ], :conditions => [
        "addresses.last_name like ? or addresses.first_name like ?",
        "%#{params[:q]}%", "%#{params[:q]}%"]
        )
    end
    @orders = @all_orders.sort_by(&:created_at).reverse.paginate(:page => params[:page], :per_page => 50)
  end

  def show
    begin
      @order = Order.find params[:id], :include => [ :shipping_address, :billing_address, :shipping_method ]
    rescue
      flash[:error] = "That order could not be found."
      redirect_to admin_orders_path
    end
  end
  
  def destroy
    @order.destroy
    respond_to :js
  end
  
  def edit
    @order = Order.find params[:id], :include => [ :shipping_address, :billing_address, :shipping_method ]
    @shipping_methods = ShippingMethod.active
    @locations = Location.find(:all, :order => "country, name")
  end
  
  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(params[:order]) and @order.shipping_address.update_attributes(params[:shipping_address])
      flash[:notice] = "Order #{@order.id} updated."
      redirect_to admin_orders_path
    else
      render :action => "edit"
    end
  end

end
