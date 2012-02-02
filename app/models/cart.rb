class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  
  def add_product(product_id)
    current_item = line_items.find_by_product_id(product_id)
    
    if current_item
       current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product_id)
    end    
    current_item
  end
  
  def total_price
       #sums = cart.line_items.group(:product_id).sum(:quantity)
    line_items.to_a.sum { |item| item.total_price }
  end
  
    def decrease(line_item_id)
    current_item = line_items.find(line_item_id)
    if current_item.quantity > 1
      current_item.quantity -= 1
    else
      current_item.destroy
    end
    current_item
  end

  
  
end

# == Schema Information
#
# Table name: carts
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

