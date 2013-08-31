class StoreController < ApplicationController
  def index
    @products = Product.order(:title)

    # Rails Play Time - Ch.9 Depot_d
    # count = increment_cunter
    # @count = count if session[:counter] >= 5
  end
end
