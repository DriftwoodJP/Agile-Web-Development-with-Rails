class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  # Rails Play Time - Ch.9 Depot_d
  def increment_cunter
    session[:counter] ||= 0
    session[:counter] += 1
  end
  def increment_cunter_reset
    session[:counter] = 0
  end

end
