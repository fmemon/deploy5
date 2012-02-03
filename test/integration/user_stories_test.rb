require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :all
  #fixtures :products

  # A user goes to the index page.
  # They select a product, adding it to their cart,
  # and check out,
  # filing in their details on the checkout form.
  # When they submit, an order is created containing their information,
  # along with a single line item corresponding to the product they added to their cart.
  # then when the ship date is updated the shipped email will do out
  
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    get "/"
    assert_response :success
    assert_template "index"
    
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success 
    
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product
    
    get "/orders/new"
    assert_response :success
    assert_template "new"
    
    post_via_redirect "/orders",
                      order: { name:     "Dave Thomas",
                               address:  "123 The Street",
                               email:    "dave@example.com",
                               pay_type_id: pay_types(:one).id}
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size
    
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]
    
    assert_equal "Dave Thomas",      order.name
    assert_equal "123 The Street",   order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check",            order.pay_type.name
    
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    
    ship_date = Time.now.to_date 
    order.ship_date = ship_date
    post_via_redirect "/orders", id: order.to_param
    assert_equal ship_date, order.ship_date.to_date  
    
  end
  
 test "should mail the admin when error occurs" do
    get "/carts/wibble" 
    assert_response :redirect  # should redirect to...
    assert_template "/"        # ...store index

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.org"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal "App Errored", mail.subject
  end

end
