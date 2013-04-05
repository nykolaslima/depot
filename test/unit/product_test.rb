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
    product = Product.new(title: 'My book title', description: 'some description', image_url: 'mybook.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    
    product.price = -0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    
    product.price = 1
    assert product.valid?
  end
  
  test "image_url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end
  
  def new_product(image_url)
    Product.new(title: 'My book title', description: 'some description', price: 9.99, image_url: image_url)
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:tdd).title, description: 'xxx', price: 9.99, image_url: 'fred.gif')
    
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
  
  test "product title should have at least 10 characters" do
    product = Product.new(title: 'Title', description: 'xxx', price: 9.99, image_url: 'fred.gif')
    
    assert product.invalid?, "title with less than 10 characters shouldn't be valid"
    assert_equal ["Hey, this title is too short!"], product.errors[:title]
  end
end
