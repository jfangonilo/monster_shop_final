class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.create(item_params)
    if @item.save
      redirect_to "/admin/merchants/#{@merchant.id}/items"
    else
      generate_error(@item)
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.find(params[:item_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.find(params[:item_id])
    @item.update(item_params)
    if @item.save
      redirect_to "/items/#{@item.id}"
    else
      generate_error(@item)
      render :edit
    end
  end

  def toggle_active
    item = Item.find(params[:id])
    item.toggle!(:active?)
    redirect_to "/admin/merchants/#{item.merchant.id}/items"
    if item.active?
      flash[:success] = "#{item.name} is now avalible for sale."
    else
      flash[:success] = "#{item.name} is no longer for sale."
    end
  end

private

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end
end