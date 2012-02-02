require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
	test "product attributes must not be empty" do
		product = Product.new
		assert product.invalid?
		assert product.errors[:title].any?
		assert product.errors[:description].any?
		assert product.errors[:price].any?
		assert product.errors[:image_url].any?
	end

	test "product price must be positive" do
		product = Product.new(title: "My Book Title",
		                                        description: "yyy",
		                                         image_url: "zzz.jpg")
		product.price = -1
		assert product.invalid?
		assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')
		
		product.price = 0
		assert product.invalid?
		assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')
		
		product.price = 1
		assert product.valid?	
	end
	
	def new_product(image_url)
	  Product.new(title: "My Book Title",
		                      description: "yyy",
		                      price: 1,
		                      image_url: image_url)
	end
	
  test "image url" do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{fred.doc fred.jpg/more fred.png.pre FRED.JP FRED.Jpng http://a.b.c/x/y/z/fred.gi }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end
  
  test "product is not valid without a unique title" do
    product = 	  Product.new(title: products(:ruby).title,
		                      description: "yyy",
		                      price: 1,
		                      image_url: "fred.gif")
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join(';')
  end

  test "product is not valid with a short title" do
    product = 	  Product.new(title: "a"*3,
		                      description: "yyy",
		                      price: 1,
		                      image_url: "fred.gif")
    assert !product.save
    assert_equal "is too short (minimum is 6 characters)", product.errors[:title].join(';')
  end
  
    test "product is not valid with a long title" do
    product = 	  Product.new(title: "a"*41,
		                      description: "yyy",
		                      price: 1,
		                      image_url: "fred.gif")
    assert !product.save
    assert_equal "is too long (maximum is 40 characters)", product.errors[:title].join(';')
  end

end


# == Schema Information
#
# Table name: products
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  image_url   :string(255)
#  price       :decimal(, )
#  created_at  :datetime
#  updated_at  :datetime
#

