class User::OrdersController < User::BaseController

  def new
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.create(order_params)
    if order.save
      create_order(order)
      session.delete(:cart)
      session.delete(:coupon)
      flash[:notice] = "Order Placed"
      redirect_to profile_orders_path
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def index
    @orders = current_user.orders
  end

  def cancel
    @order = current_user.orders.find(params[:id])
    @order.cancel
    flash[:notice] = "Order Cancelled"
    redirect_to profile_path
  end

private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def create_order(order)
    if coupon
      apply_discount(order)
      order.update(coupon: coupon)
    else
      no_discount(order)
    end
  end

  def apply_discount(order)
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.discount_if_applicable(coupon)
        })
    end
  end

  def no_discount(order)
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.price
        })
    end
  end
end
