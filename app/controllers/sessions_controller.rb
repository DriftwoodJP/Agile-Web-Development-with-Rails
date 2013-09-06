class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create
    if User.count.zero?
      redirect_to new_user_path
    else
      user = User.find_by_name(params[:name])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to admin_url
      else
        redirect_to login_url, alert: "無効なユーザー/パスワードの組合せです"
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_url, notice: "ログアウト"
  end
end
