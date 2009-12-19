class BillingAddressesController < CheckoutController
  filter_parameter_logging :card
  before_filter :get_locations

  def new
    @billing_address = session[:billing_address].blank? ? BillingAddress.new : session[:billing_address]

    if session[:card].blank?
      @card = Card.new
    else
      @card = Card.new(
        :card_type => session[:card]['card_type'],
        :card_number => session[:card]['card_number'],
        :month => session[:card]['exp_month'],
        :year => session[:card]['exp_year']
      )
    end
  end
  
  def create
    # Always validate the billing address when form is submitted.
    # Only validate the card if a new card was entered.

    @billing_address = BillingAddress.new(params[:billing_address])
    @card = Card.new(params[:card])
    @cart = session[:cart]

    # Our billing address passed form validation, save it in session.
    if @billing_address.valid?
      session[:billing_address] = @billing_address
      billing_location = Location.find(@billing_address.location_id)
      
      # Handle taxes for california
      if billing_location.sales_tax_rate != nil
        @cart.update_taxes_total(@cart.subtotal * (billing_location.sales_tax_rate.to_f / 100.0))
      else
        @cart.update_taxes_total(0)
      end
    end

    # If we have new card information, validate the new card and
    # attempt to authorize the order amount before moving on.
    if !@card.card_number.match(/XXX/)

      # Ensure card session information is gone
      session[:card] = {}

      # First, check to see if the form validation for the card passed.
      # If did, we will attempt the ActiveMerchant validation and authorization.
      if @card.valid?

        # Create ActiveMerchant credit card for testing and authorization.
        creditcard = ActiveMerchant::Billing::CreditCard.new(
          :type => @card.card_type,
          :number => @card.card_number.gsub(/\D/,'').to_i,
          :month => @card.month.to_i,
          :year => @card.year.to_i,
          :verification_value => @card.security_code.to_i,
          :first_name => @billing_address.first_name.strip,
          :last_name => @billing_address.last_name.strip
        )

        # The credit card passes ActiveMerchant regexp validation.
        if creditcard.valid?
          
          # Attempt to authorize the card for the order total.
          gateway = ActiveMerchant::Billing::Base.gateway(:pay_junction).new(:login => $PAYJUNCTION_LOGIN, :password => $PAYJUNCTION_PASSWORD)

          amount = @cart.total_in_cents
          response = gateway.authorize(amount, creditcard)

          if response.success?
            # Aithorize was successful, so store limited card information and 
            # move on to the next checkout step.
            logger.info response.to_yaml
            session[:card]['card_number'] = creditcard.display_number
            session[:card]['card_type'] = @card.card_type
            session[:card]['exp_month'] = @card.month
            session[:card]['exp_year'] = @card.year
            session[:card]['authorization'] = response.authorization
            session[:card]['authorization_amount'] = amount
            redirect_to checkout_path
            return
          else
            # The authorization failed. Show the error message and redirect to
            # the billing page so they may correct the problem.
            flash[:error] = "Unable to authorize your card. #{response.message}"
          end

        else
          # ActiveMerchant card format validations failed.
          flash[:error] = "The card you entered is invalid. #{creditcard.errors.full_messages.join(', ')}."
        end # creditcard.valid?
        
      end # @card.valid?
      
    elsif @billing_address.valid?

      # Existing card was used and the billing address was valid, so we will
      # just redirect them to the final step of checkout.
      redirect_to checkout_path
      return

    end # new card being used?
    
    # If we get to this point, some kind of error happened, so we simply
    # render the view to show the problems. Either the card or billing_address
    # validation failed.
    render :action => "new"

  end # create method
    

  private
  
  def get_locations
    @locations = Location.find(:all, :order => "country, name")
  end
  
end
