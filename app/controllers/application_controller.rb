class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart,
                :coupon,
                :current_user,
                :current_merchant_user?,
                :current_admin_user?,
                :current_employee?

  def cart
    session[:cart] ||= Hash.new(0)
    @cart ||= Cart.new(session[:cart])
  end

  def coupon
    @coupon = Coupon.find_by(name: session[:coupon]["name"]) if session[:coupon]
  end

  def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_merchant_user?
    current_user && (current_user.merchant_employee? || current_user.merchant_admin?)
  end

  def current_admin_user?
    current_user && current_user.admin_user?
  end

  def current_employee?(merchant)
    current_merchant_user? && (current_user.merchant.id == merchant.id)
  end

  def generate_error(resource)
    flash[:error] = resource.errors.full_messages.to_sentence
  end

  def require_merchant
    render file: "/public/404", status: 404 unless current_merchant_user?
  end

  def require_admin
    render file: "/public/404", status: 404 unless current_admin_user?
  end

  def require_user
    render file: "/public/404", status: 404 unless current_user
  end

  def exclude_admin
    render file: "/public/404", status: 404 if current_admin_user?
  end
end
