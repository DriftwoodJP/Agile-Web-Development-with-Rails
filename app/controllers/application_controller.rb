class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  before_filter :set_i18n_locale_from_params

  private
  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  def authorize
    unless request.format == Mime::HTML
      authenticate_or_request_with_http_basic do |n,p|
        user = User.find_by_name(n)
        if user && user.authenticate(p)
          session[:user_id] = user.id
        end
      end
    else
      return if User.count.zero?

      unless User.find_by_id(session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end
  end

  # Rails Play Time - Ch.9 Depot_d
  # def increment_cunter
  #   session[:counter] ||= 0
  #   session[:counter] += 1
  # end
  # def increment_cunter_reset
  #   session[:counter] = 0
  # end

end
