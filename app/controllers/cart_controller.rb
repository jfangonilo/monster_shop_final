class CartController < ApplicationController
  before_action :exclude_admin

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to items_path
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to cart_path
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to cart_path
  end

  def add_subtract_cart
    if params[:add_subtract] == "add"
      cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
    elsif params[:add_subtract] == "subtract"
      cart.subtract_quantity(params[:item_id])
      return remove_item if cart.quantity_zero?(params[:item_id])
    end
    redirect_to cart_path
  end
end
