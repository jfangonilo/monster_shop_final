require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
    it { should define_enum_for(:status).with_values([:unfulfilled, :fulfilled]) }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'instance methods' do
    it 'subtotal' do
      user = create(:regular_user)
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(200)
    end

    it 'fulfill' do
      item_1 = create(:random_item, inventory: 7)
      order_1 = create(:random_order)
      item_order_1 = create(:item_order, order: order_1, item: item_1, quantity: 5)

      item_order_1.fulfill
      expect(item_order_1.fulfilled?).to be(true)
      expect(item_1.inventory).to eq(2)
    end

    it 'fulfillable?' do
      user = create(:random_user)
      item_1 = create(:random_item, inventory: 7)
      order_1 = create(:random_order, user: user)
      item_order_1 = create(:item_order, order: order_1, item: item_1, quantity: 5)
      expect(item_order_1.fulfillable?).to eq(true)

      item_2 = create(:random_item, inventory: 1)
      order_2 = create(:random_order, user: user)
      item_order_2 = create(:item_order, order: order_2, item: item_2, quantity: 5)
      expect(item_order_2.fulfillable?).to eq(false)
    end
  end

end
