class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = Coupon.all
  end

  def new
    @merchant = current_user.merchant
    @coupon = Coupon.new
  end

  def create
    merchant = current_user.merchant
    @coupon = merchant.coupons.create(coupon_params)
    if @coupon.save
      flash[:success] = "New Coupon Created"
      redirect_to "/merchant/coupons"
    else
      generate_error(@coupon)
      render :new
    end
  end

  def show
    merchant = current_user.merchant
    @coupon = merchant.coupons.find(params[:id])
  end

private

  def coupon_params
    params.require(:coupon).permit(:name,:code,:percent_off)
  end
end