class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = Coupon.all
  end

  def show
    merchant = current_user.merchant
    @coupon = merchant.coupons.find(params[:id])
  end
end