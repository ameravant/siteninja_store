class OrdersController < CheckoutController
  before_filter :validate_checkout_step
  
  def new
    @checkout = true
    @order = Order.new
    @cart = session[:cart]
    @cart_items = @cart.items
    begin
      # Get location records for chosen locations
      @shipping_location = Location.find(session[:shipping_address]['location_id'])
      @billing_location = Location.find(session[:billing_address]['location_id'])
    rescue
      redirect_to shipping_path
    end
  end
  
  def create
    flash[:error] = nil
    gateway = ActiveMerchant::Billing::Base.gateway(:pay_junction).new(:login => $PAYJUNCTION_LOGIN, :password => $PAYJUNCTION_PASSWORD)
    response = gateway.capture(session[:cart].total_in_cents, session[:card]['authorization'])

    if response.success?
      @cart = session[:cart]
      @cart_items = @cart.items

      # Record order
      @order = Order.create(
        :ip_address => request.remote_addr,
        :billing_status => response.message,
        :response => response,
        :shipping_method_id => session[:shipping_method][:id],
        :subtotal => @cart.subtotal,
        :shipping_total => @cart.shipping_total,
        :taxes_total => @cart.taxes_total,
        :total => @cart.total,
        :card_type => session[:card]['card_type'],
        :card_number => session[:card]['card_number'] # masked number
      )
    
      # Record order items
      for i in @cart_items
        @order.order_items.create(
          :name => i.name,
          :permalink => i.permalink,
          :quantity => i.quantity,
          :price => i.price,
          :sale_price => i.sale_price,
          :real_price => i.real_price,
          :total => i.total
        )
      end

      @shipping_address = ShippingAddress.create(
        :order_id => @order.id,
        :location_id => session[:shipping_address]['location_id'],
        :first_name => session[:shipping_address]['first_name'],
        :last_name => session[:shipping_address]['last_name'],
        :street_address => session[:shipping_address]['street_address'],
        :street_address_2 => session[:shipping_address]['street_address_2'],
        :city => session[:shipping_address]['city'],
        :postal_code => session[:shipping_address]['postal_code'],
        :phone => session[:shipping_address]['phone'],
        :email => session[:shipping_address]['email']
      )
    
      @billing_address = BillingAddress.create(
        :order_id => @order.id,
        :location_id => session[:billing_address]['location_id'],
        :first_name => session[:billing_address]['first_name'],
        :last_name => session[:billing_address]['last_name'],
        :street_address => session[:billing_address]['street_address'],
        :street_address_2 => session[:billing_address]['street_address_2'],
        :city => session[:billing_address]['city'],
        :postal_code => session[:billing_address]['postal_code']
      )

      # Send email receipt
      begin
        OrderMailer.deliver_receipt(@order)
        OrderMailer.deliver_notification(@order)
      rescue
        # move on if we can't
      end
    
      reset_session
      @menu_selected = "products"
      # Render create.erb
    
    else # capture failed!

      # First, void the authorized transaction since we cannot use it
      response = gateway.void(session[:card]['authorization'])
    
      # Next, clear the card information in the users session
      session[:card] = {}
    
      # Finally, redirect them back to the billing step with an error message.
      flash[:error] = "We were unable to process your payment. #{response.message}. Please enter new card information below to retry."
      redirect_to billing_path

    end
  end


  private
  
  def validate_checkout_step
    if session[:shipping_address].blank? or session[:shipping_method].blank?
      redirect_to shipping_path
    elsif session[:billing_address].blank? or session[:card].blank?
      redirect_to billing_path
    elsif session[:cart].blank?
      redirect_to products_path
    end
  end

end
