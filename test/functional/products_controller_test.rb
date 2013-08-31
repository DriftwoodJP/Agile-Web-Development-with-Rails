require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @update = {
      title:       'Lorem ipsum.',
      description: 'Wibbles are fun!',
      image_url:   'lorem.jpg',
      price:       19.95
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
    # Rails Play Time - Ch.8 Depot_c
    assert_select '.products', 1
    assert_select '.list_actions a', minimum: 3
  end

  test "link hrefs should not be empty for actions" do
    get :index
    assert_select "td.list_actions a" do
      assert_select "[href=?]", /.+/  # Not empty
    end
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
    get :show, id: @product
    assert_response :success
  end

  # Rails Play Time - Ch.10 Depot_e
  test "should attempt to access invalid nonexistent product id" do
    get :show, id: 999
    assert_redirected_to products_url
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    put :update, id: @product.to_param, product: @update
    assert_redirected_to product_path(assigns(:product))
  end

  # Rails Play Time - Ch.10 Depot_e
  test "can't delete product in cart" do
    assert_difference('Product.count', 0) do
      delete :destroy, id: products(:ruby).to_param
    end
    assert_redirected_to products_path
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product.to_param
    end

    assert_redirected_to products_path
  end

end
