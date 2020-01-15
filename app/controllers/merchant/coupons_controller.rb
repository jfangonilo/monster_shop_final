class Merchant::CouponsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
    @coupons = merchant.coupons
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
      redirect_to merchant_dash_coupons_path
    else
      generate_error(@coupon)
      render :new
    end
  end

  def edit
    merchant = current_user.merchant
    @coupon = merchant.coupons.find(params[:id])
  end

  def update
    merchant = current_user.merchant
    @coupon = merchant.coupons.find(params[:id])
    @coupon.update(coupon_params)
    if @coupon.save
      flash[:success] = "Coupon Updated"
      redirect_to merchant_dash_coupon_path(@coupon)
    else
      generate_error(@coupon)
      render :edit
    end
  end

  def show
    merchant = current_user.merchant
    @coupon = merchant.coupons.find(params[:id])
  end

  def destroy
    merchant = current_user.merchant
    @coupon = merchant.coupons.find(params[:id])
    @coupon.destroy
    flash[:success] = "Coupon Deleted"
    redirect_to merchant_dash_coupons_path
  end

private

  def coupon_params
    params.require(:coupon).permit(:name,:code,:percent_off)
  end
end