class ShippingAddressesController < CheckoutController
  before_filter :get_dropdown_data

  def new
    @shipping_address = session[:shipping_address].blank? ? ShippingAddress.new : session[:shipping_address]

    # Get the currently selected shipping method for session, if it exists.
    begin
      @shipping_method = ShippingMethod.find(session[:shipping_method][:id]) unless session[:shipping_method].blank?
    rescue
      redirect_to shipping_path
    end
  end
  
  def create
    @cart = session[:cart]
    @shipping_address = ShippingAddress.new(params[:shipping_address])

    # Update the session and cart shipping information.
    begin
      @shipping_method = ShippingMethod.find(params[:shipping_method]['id'])
      session[:shipping_method] = { :id => @shipping_method.id, :name => @shipping_method.name }
      @cart.update_shipping_total(@shipping_method.price)
    rescue
      redirect_to shipping_path
    end

    # Validate shipping information was entered, save it to session.
    if @shipping_address.valid?
      session[:shipping_address] = @shipping_address

      # Duplicate shipping address as billing address if checkbox marked, and billing 
      # address does not exist yet.
      if params[:same_addresses] == "yes" and session[:billing_address].blank?
        session[:billing_address] = BillingAddress.new(params[:shipping_address])
      end

      # Redirect to appropriate step mattering what information is completed.
      session[:billing_address].blank? or session[:card].blank? ? redirect_to(billing_path) : redirect_to(checkout_path)
    else
      # Shipping address form validation failed.
      render :action => "new"
    end

  end
  
  private
  
  def get_dropdown_data
    @locations = Location.find(:all, :order => "country, name")
    @shipping_methods = ShippingMethod.active
  end
  
end
