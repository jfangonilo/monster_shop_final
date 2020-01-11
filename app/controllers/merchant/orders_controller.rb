class Merchant::OrdersController < Merchant::BaseController
  def show
    merchant = current_user.merchant
    @order = merchant.orders.find(params[:id])
    @item_orders = merchant.item_orders_from(@order)
  end

  def fulfill
    merchant = current_user.merchant
    order = merchant.orders.find(params[:order_id])
    item_order = order.item_orders.find(params[:item_order_id])
    item_order.fulfill
    order.package_if_fulfilled
    redirect_to merchant_dash_order_path(order)
  end
end