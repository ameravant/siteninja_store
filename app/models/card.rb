class Card < ActiveRecord::Base
  validates_presence_of :card_number, :month, :year, :security_code
  validates_numericality_of :month, :year, :security_code, :allow_blank => true
  belongs_to :order
  before_save :force_security_code_nil
  
  private
  
  def force_security_code_nil
    self.security_code = nil
  end
end