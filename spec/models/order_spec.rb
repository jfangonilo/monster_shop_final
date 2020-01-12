require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should define_enum_for(:status).with_values([:packaged, :pending, :shipped, :cancelled]) }
  end

  describe "relationships" do
    it { should have_many :item_orders }
    it { should have_many(:items).through(:item_orders) }
    it { should belong_to :user }
    it { should belong_to(:coupon).optional }
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @user = create(:regular_user)
      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'cancel' do
      merchant = create(:jomah_merchant)
      items = create_list(:random_item, 5, merchant: merchant, inventory: 10)
      order = create(:random_order, user: @user)
      items.each do |item|
        create(:item_order, order: order, item: item, price: item.price, quantity: 5)
      end

      order.cancel
      expect(order.cancelled?).to be true
      order.item_orders.each do |item_order|
        expect(item_order.unfulfilled?).to be true
      end
      merchant.items.each do |item|
        expect(item.inventory).to eq 15
      end
    end

    it 'package_if_fulfilled' do
      @order_1.package_if_fulfilled
      expect(@order_1.packaged?).to be false

      @order_1.item_orders.each do |item_order|
        item_order.update(status: "fulfilled")
      end

      @order_1.package_if_fulfilled
      expect(@order_1.packaged?).to be true
    end

    it 'quantity_ordered' do
      expect(@order_1.quantity_ordered).to eq 5
    end

    it 'quantity_ordered_from' do
      expect(@order_1.quantity_ordered_from(@meg)).to eq 2
    end

    it 'subtotal_from' do
      expect(@order_1.subtotal_from(@meg)).to eq 200
    end
  end

  describe 'class methods' do
    it 'sort_by_status' do
      user = create(:random_user)

      order_4 = create(:random_order, user: user, status: "cancelled")
      order_1 = create(:random_order, user: user, status: "pending")
      order_3 = create(:random_order, user: user, status: "shipped")
      order_2 = create(:random_order, user: user, status: "packaged")

      expect(Order.sort_by_status).to eq [order_2, order_1, order_3, order_4]
    end
  end
end
