require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    # ユーザーがインデックスページを訪れる
    get "/"
    assert_response :success
    assert_template "index"

    # ユーザーが商品を選択し、カートに入れる
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # ユーザーはチェックアウトする
    get "/orders/new"
    assert_response :success
    assert_template "new"

    # ユーザーはデータを記入し、送信を行う
    post_via_redirect "/orders",
      order: { name:        "Dave Thomas",
               address:     "123 The Street",
               email:       "dave@example.com",
               pay_type_id: 1}
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    # （データベースを参照する）
    # 注文と対応する品目が作成されており、細目が適切なことを確認する
    # 新しい注文だけ含まれる
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Dave Thomas",       order.name
    assert_equal "123 The Street",    order.address
    assert_equal "dave@example.com",  order.email
    assert_equal 1,                   order.pay_type_id

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    # （メールのアドレスと件名が正しいことを検証します）
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  # 発送処理と発送完了メールの送信
  test "shipping a product" do
    # login user
    user = users(:one)
    get "/login"
    assert_response :success
    post_via_redirect "/login", name: user.name, password: 'secret'
    assert_response :success
    assert_equal '/admin', path

    get "/orders"
    assert_response :success

    # 発送を完了する
    order = orders(:one)
    get update_ship_date_order_path(order)
    assert_response :redirect
    assert_template "orders"
    # ship_date = Time.now.in_time_zone
    # assert_equal ship_date, order.ship_date
    # assert_select "", ship_date

    # 顧客へ発送メールが送信される
    # （メールのアドレスと件名が正しいことを検証します）
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.org"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_equal "Pragmatic Store Order Shipped", mail.subject
  end

  test "should mail the admin when error_occured" do
    # login user
    user = users(:one)
    get "/login"
    assert_response :success
    post_via_redirect "/login", name: user.name, password: 'secret'
    assert_response :success
    assert_equal '/admin', path

    # logout user
    # delete "/logout"
    # assert_response :redirect
    # assert_template "/"

    get "/carts/wibble"
    assert_response :redirect
    assert_template "/"

    mail = ActionMailer::Base.deliveries.last
    assert_equal "Depot App Error Incident", mail.subject
    assert_equal "Sam Ruby <depot@example.com>", mail[:to].value
    assert_equal ["system@example.com"], mail.from
  end

  test "should fail on access of sensitive data" do
    # login user
    user = users(:one)
    get "/login"
    assert_response :success
    post_via_redirect "/login", name: user.name, password: 'secret'
    assert_response :success
    assert_equal '/admin', path

    # look at a protected resource
    get "/carts/12345"
    assert_response :success
    assert_equal '/carts/12345', path

    # logout user
    delete "/logout"
    assert_response :redirect
    assert_template "/"

    #try to look at protected resource again, should be redirected to login page
    get "/carts/12345"
    assert_response :redirect
    follow_redirect!
    assert_equal '/login', path
  end

  test "should logout and not be allowed back in" do
    delete "/logout"
    assert_redirected_to store_url

    get "/users"
    assert_redirected_to login_url
  end

end
