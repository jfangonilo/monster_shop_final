require "rails_helper"

RSpec.describe Cart do
  describe "methods" do
    before :each do
      @session = Hash.new(0)
      @item = create(:random_item)
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
  end
end
