class CouponController < ApplicationController
  def update
    coupon = Coupon.find_by(code: params[:coupon])
    if coupon
      session[:coupon_id] = coupon.id
      flash[:success] = "Coupon applied for #{coupon.merchant.name} items"
      redirect_back(fallback_location: "/cart")
    else
      flash[:error] = "Invalid Coupon"
      redirect_back(fallback_location: "/cart")
    end
  end
end