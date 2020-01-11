class Admin::MerchantsController < ApplicationController
  def show
    @merchant = Merchant.find(params[:id])
  end

  def index
    @merchants = Merchant.all
  end

  def toggle_active
    merchant = Merchant.find(params[:merchant_id])
    merchant.toggle!(:active)
    if merchant.active?
      merchant.items.update_all(active?: true)
      flash[:notice] = "Merchant has been deactivated"
      redirect_to admin_dash_merchants_path
    else
      merchant.items.update_all(active?: false)
      flash[:notice] = "Merchant has been activated"
      redirect_to admin_dash_merchants_path
    end
  end
end
