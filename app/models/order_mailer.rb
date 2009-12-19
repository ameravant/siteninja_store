class OrderMailer < ActionMailer::ARMailer

  # default_url_options[:host] = $DOMAIN_PATH.gsub("http://","")

  def receipt(order)
    settings = Setting.cached
    order_items = order.order_items
    shipping_method = order.shipping_method
    shipping_address = order.shipping_address
    billing_address = order.billing_address
    
    setup_email(shipping_address.email, settings.order_receipt_from_email, settings.order_receipt_subject)

    body[:settings] = settings
    body[:order] = order
    body[:order_items] = order_items
    body[:shipping_method] = shipping_method
    body[:shipping_address] = shipping_address
    body[:billing_address] = billing_address
  end
  
  def notification(order)
    settings = Setting.cached
    order_items = order.order_items
    shipping_method = order.shipping_method
    shipping_address = order.shipping_address
    billing_address = order.billing_address
    
    setup_email(settings.order_notification_email, settings.order_receipt_from_email, "New order placed (##{order.id})")

    body[:settings] = settings
    body[:order] = order
    body[:order_items] = order_items
    body[:shipping_method] = shipping_method
    body[:shipping_address] = shipping_address
    body[:billing_address] = billing_address
  end

  private
  
  def setup_email(email_to, email_from, subject, reply_to=nil, content_type='text/html')
    recipients   email_to.strip
    from         email_from.strip
    headers      'Reply-to' => (reply_to ? reply_to.strip : email_from.strip)
    subject      subject
    sent_on      Time.now
    content_type content_type
  end

end
