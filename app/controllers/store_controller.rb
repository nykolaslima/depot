class StoreController < ApplicationController
  def index
    counter = session[:counter] || 0
    session[:counter] = counter + 1
    @products = Product.order(:title)
  end
end
