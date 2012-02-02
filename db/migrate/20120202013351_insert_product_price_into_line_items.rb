class InsertProductPriceIntoLineItems < ActiveRecord::Migration
  def up
    LineItem.all.each do |item|
      item.price = Product.find(item.product_id).price
      item.save
    end

  end

  def down
    LineItem.all.each do |item|
      item.price = nil
    end
  end
end
