class CombineItemsInCart < ActiveRecord::Migration
  def up
   Cart.all.each do |cart|
     sums = cart.line_items.group(:product_id).sum(:quantity)
     sums.each do |product_id, quantity| 
        if quantity > 1
          cart.line_items.find_by_product_id(product_id).destroy
          cart.line_items.create(product_id: product_id, quantity: quantity)
        end
     end
   end
  end

  def down
    #split the line items with quantity > 1 into multiple items
    LineItem.where("quantity > 1").each do |line_item|
      line_item.quantity.times do 
        LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1
      end
      
      #now destroy the original item
      line_item.destroy
    end
  end
end