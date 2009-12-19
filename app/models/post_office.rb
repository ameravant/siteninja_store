# class PostOffice < ActionMailer::ARMailer
class PostOffice < ActionMailer::Base

  def newsletter(newsletter, blast_id, contact_id, name, email, server_name, server_port)
    settings = Setting.cached
    setup_email(email, settings.newsletter_from, newsletter.subject)

    body :name => name, :blast_id => blast_id, :contact_id => contact_id, :email => email,
      :newsletter => newsletter, :settings => settings, :server_name => server_name,
      :server_port => server_port
  end
  
  def help_request_for_gyroxus(help_request)
    settings = Setting.cached
    setup_email(
      settings.help_request_notification_email,
      settings.help_request_from_email,
      "Help Request ##{help_request.id}",
      help_request.email,
      "text/plain")
    body :help_request => help_request
  end
  
  def help_request_for_visitor(help_request)
    settings = Setting.cached
    setup_email(
      help_request.email,
      settings.help_request_from_email,
      "Help Request Received",
      nil,
      "text/plain")
    body :help_request => help_request
  end
  
  private
  
  def setup_email(email_to, email_from, subject, reply_to=nil, content_type='text/html')
    recipients   email_to.strip
    from         email_from.strip
    headers      'Reply-to' => (reply_to ? reply_to.strip : email_from.strip)
    subject      subject.strip
    sent_on      Time.now
    content_type content_type
  end

end