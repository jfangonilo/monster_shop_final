class Admin::OrdersController < Admin::BaseController
  def ship
    user = User.find(params[:user_id])
    order = user.orders.find(params[:order_id])
    order.update(status: "shipped")
    redirect_to "/admin"
  end

  def show
    user = User.find(params[:user_id])
    @order = user.orders.find(params[:order_id])
  end

  def cancel
    user = User.find(params[:user_id])
    @order = user.orders.find(params[:order_id])
    @order.cancel
    flash[:notice] = "Order Cancelled"
    redirect_to "/admin/users/#{user.id}/orders/#{@order.id}"
  end
end
