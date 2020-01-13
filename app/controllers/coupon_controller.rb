class CouponController < ApplicationController
  def apply_coupon
    coupon = Coupon.find_by(code: params[:coupon])
    if coupon
      session[:coupon] = coupon
      flash[:success] = "Coupon applied for #{coupon.merchant.name} items"
      redirect_to "/cart"
    else
      flash[:error] = "Invalid Coupon"
      redirect_to "/cart"
    end
  end
end