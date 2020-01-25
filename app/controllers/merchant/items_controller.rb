class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
    @items = @merchant.items
  end

  def new
    @merchant = current_user.merchant
    @item = Item.new
  end

  def create
    @merchant = current_user.merchant
    @item = @merchant.items.create(item_params)
    if @item.save
      redirect_to "/merchant/items"
    else
      generate_error(@item)
      render :new
    end
  end

  def edit
    @merchant = current_user.merchant
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    if @item.save
      redirect_to "/merchant/items"
    else
      generate_error(@item)
      render :edit
    end
  end

  def toggle_active
    item = Item.find(params[:id])
    item.toggle!(:active?)
    redirect_to "/merchant/items"
    if item.active?
      flash[:success] = "#{item.name} is now avalible for sale."
    else
      flash[:success] = "#{item.name} is no longer for sale."
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    flash[:success] = "Item Deleted"
    redirect_to "/merchant/items"
  end

private

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end
end
