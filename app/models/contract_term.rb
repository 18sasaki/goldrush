# -*- encoding: utf-8 -*-
class ContractTerm < ActiveRecord::Base

  has_many :approaches, :conditions => ["approaches.deleted = 0"]
  
  def payment_view=(x)
    self.payment = x.to_f * 10000
  end
  
  def payment_view
    payment / 10000.0
  end
end
