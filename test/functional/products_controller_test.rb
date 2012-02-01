require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @update = {
      title: 'Lorem Ipsum',
      description: 'Wibbles are fun!',
      image_url: 'lorem.jpg',
      price: 19.95
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)

   assert_select '#columns #side a', minimum: 4
   assert_select '#main table tr', 3 
   assert_select 'dt', 'Programming Ruby 1.9'
   assert_select 'td img.list_image', 3
   assert_select 'td.list_actions > a', 9
   assert_select 'tr.list_line_odd', 2
   assert_select 'tr.list_line_even', 1
   assert_select '#banner img', 1
   assert_select 'div#banner ', 'Pragmatic Bookshelf'
   assert_select "img[src=/assets/logo.png]", 1

  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: @update 
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product.to_param
    assert_response :success
  end

  test "should update product" do
    put :update, id: @product.to_param, product: @update 
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product.to_param
    end

    assert_redirected_to products_path
  end
end
