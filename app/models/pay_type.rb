class PayType < ActiveRecord::Base
 has_many :orders
  
 def self.names
    all.collect { |payment_type| payment_type.name }
  end


end
# == Schema Information
#
# Table name: pay_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

