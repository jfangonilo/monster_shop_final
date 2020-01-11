class SessionsController < ApplicationController

  def new
    if current_admin_user?
      flash[:error] = "You are already logged in."
      redirect_to admin_dash_path
    elsif current_merchant_user?
      flash[:error] = "You are already logged in."
      redirect_to merchant_dash_path
    elsif current_user
      flash[:error] = "You are already logged in."
      redirect_to profile_path
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && !user.active?
      flash[:error] = "Sorry This Acount Is Inactive"
      render :new
    elsif login_successful?(user)
      session[:user_id] = user.id
      welcome(user)
    else
      flash[:error] = "Sorry Invalid Password or Email."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:success] = "You are now logged out."
    redirect_to "/"
  end

  private

  def login_successful?(user)
    user && user.authenticate(params[:password])
  end

  def welcome(user)
    if current_admin_user?
      flash[:success] = "Welcome Admin #{user.email}! You are logged in."
      redirect_to admin_dash_path
    elsif current_merchant_user?
      flash[:success] = "Welcome Merchant #{user.email}! You are logged in."
      redirect_to merchant_dash_path
    else
      flash[:success] = "Welcome #{user.email}! You are logged in."
      redirect_to profile_path
    end
  end
end
