class StoreSetting < ActiveRecord::Base
  validates_presence_of :footer_text, :ca_sales_tax, :newsletter_from
  #validates_presence_of :help_request_from_email, :help_request_notification_email
  validates_presence_of :order_receipt_from_email, :order_receipt_subject
  validates_numericality_of :ca_sales_tax, :allow_blank => true
  #validates_format_of :help_request_from_email, :with => /\@\S+\./, :allow_blank => true
  #validates_format_of :help_request_notification_email, :with => /\@\S+\./, :allow_blank => true
  validates_format_of :order_receipt_from_email, :with => /\@\S+\./, :allow_blank => true
  after_save :expire_cache
  has_attached_file :email_logo
  has_attached_file :newsletter_logo

  def self.cached
    if Rails.env.production?
      Rails.cache.fetch("Setting.cached") { first }
    else
      first
    end
  end
  
  private
  
  def expire_cache
    Rails.cache.delete('Setting.cached')
  end

end
