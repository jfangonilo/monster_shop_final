require "rails_helper"

RSpec.describe Cart do
  describe "methods" do
    before :each do
      @merchant = create(:jomah_merchant)
      @item = create(:random_item, merchant: @merchant, price: 100)
      @coupon =  create(:coupon_1, merchant: @merchant)

      @session = Hash.new(0)
      @session[@item.id.to_s] = 0
      @cart ||= Cart.new(@session)
    end
    it "can initialize with contents" do
      expect(@cart.contents[@item_id.to_s]).to eq(0)
    end

    it "can add items to content" do
      @cart.add_item(@item.id.to_s)
      expect(@cart.contents[@item.id.to_s]).to eq(1)
    end

    it "can count total_items" do
      @cart.add_item(@item.id.to_s)
      @cart.add_item(@item.id.to_s)
      item_2 = create(:random_item)
      @cart.add_item(item_2.id.to_s)
      expect(@cart.total_items).to eq(3)
    end

    it "can find a total item quantity" do
      @cart.add_item(@item.id.to_s)
      @cart.add_item(@item.id.to_s)
      expect(@cart.items).to eq({@item => 2})
    end

    it "can total a cart items contents" do
      @cart.add_item(@item.id.to_s)
      @cart.add_item(@item.id.to_s)
      expect(@cart.subtotal(@item)).to eq(@item.price * 2)
    end

    it "can total a cart's contents" do
      @cart.add_item(@item.id.to_s)
      @cart.add_item(@item.id.to_s)
      item_2 = create(:random_item)
      @cart.add_item(item_2.id.to_s)
      expect(@cart.total).to eq((@item.price * 2) + item_2.price)
    end

    it "add additional items to cart" do
      @cart.add_item(@item.id.to_s)
      expect(@cart.contents["#{@item.id.to_s}"]).to eq(1)
      @cart.add_quantity(@item.id.to_s)
      expect(@cart.contents["#{@item.id.to_s}"]).to eq(2)
    end

    it "can subtract item quantity from cart" do
      @cart.add_item(@item.id.to_s)
      @cart.add_item(@item.id.to_s)
      expect(@cart.contents["#{@item.id.to_s}"]).to eq(2)
      @cart.subtract_quantity(@item.id.to_s)
      expect(@cart.contents["#{@item.id.to_s}"]).to eq(1)
    end

    it "can see if a cart's item quantity is more than inventory total" do
      item_2 = create(:random_item, inventory: 3)
      @cart.add_item(item_2.id.to_s)
      @cart.add_item(item_2.id.to_s)
      expect(@cart.limit_reached?(item_2.id.to_s)).to eq(false)
      @cart.add_item(item_2.id.to_s)
      expect(@cart.limit_reached?(item_2.id.to_s)).to eq(true)
    end

    it "can set cart contents to zero" do
      expect(@cart.quantity_zero?(@item.id.to_s)).to eq(true)
      @cart.add_item(@item.id.to_s)
      expect(@cart.quantity_zero?(@item.id.to_s)).to eq(false)
    end

    it "discounted_subtotal" do
      @session[@item.id.to_s] = 1
      expect(@cart.discounted_subtotal(@item, @coupon)). to eq 50
    end

    it "discounted_total" do
      item_2 = create(:random_item, price: 50, merchant: @merchant)
      item_3 = create(:random_item, price: 50)

      @session[@item.id.to_s] = 1
      @session[item_2.id.to_s] = 2
      @session[item_3.id.to_s] = 1

      expect(@cart.discounted_total(@coupon)). to eq 150
    end
  end
end
