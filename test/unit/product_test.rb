require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(title:       'My book title',
                          description: 'yyy',
                          image_url:   'zzz.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal 'must be greater than or equal to 0.01',
      product.errors[:price].join('; ')

    product.price = 0
    assert product.invalid?
    assert_equal 'must be greater than or equal to 0.01',
      product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title:       'My Book Title',
                description: 'yyy',
                price:       1,
                image_url:   image_url)
  end
  test "image url" do
    ok =  %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title:       products(:ruby).title,
                          description: 'yyy',
                          price:       1,
                          image_url:   'fred.gif')
    assert !product.save
    # assert_equal "has already been taken",
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
      product.errors[:title].join('; ')
  end

  test "product is not valid without a title of at least 10 characters" do
    product = Product.new(title:       '123456789',
                          description: 'yyy',
                          price:       1,
                          image_url:   'fred.gif')
    assert !product.save
    assert_equal I18n.translate('errors.messages.too_short', :count => 10),
      product.errors[:title].join('; ')
  end

  # Rails Play Time - Ch.10 Depot_e
  test "product is not valid without a unique image_url" do
    product = Product.new(title:       'My Book Title',
                          description: 'yyy',
                          price:       1,
                          image_url:   products(:ruby).image_url)
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
      product.errors[:image_url].join('; ')
  end
  test "product price must be 'price < 1000'" do
    product = Product.new(title:       'My book title',
                          description: 'yyy',
                          image_url:   'zzz.jpg')
    product.price = 1001
    assert product.invalid?
    # assert_equal 'must be less than or equal to 1000',
    assert_equal I18n.translate('errors.messages.less_than_or_equal_to', :count => 1000),
      product.errors[:price].join('; ')

    product.price = 1000
    assert product.valid?

    product.price = 999
    assert product.valid?
  end

end
