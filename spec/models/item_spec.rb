require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    # it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      user = create(:regular_user)
      order = user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it "discounted_price" do
      expect(@chain.discounted_price(0.5)).to eq 25
    end

    it 'can find top five selling items' do
      user = create(:regular_user)
      order = create(:random_order, user: user)
      order_new = create(:random_order, user: user)

      dog_bone = create(:random_item)
      mug = create(:random_item)
      boot = create(:random_item)
      shirt = create(:random_item)
      hat = create(:random_item)
      cookie = create(:random_item)
      pants = create(:random_item)

      ItemOrder.create(item: dog_bone, order: order, price: dog_bone.price, quantity: 9)
      ItemOrder.create(item: dog_bone, order: order_new, price: dog_bone.price, quantity: 2)
      ItemOrder.create(item: dog_bone, order: order_new, price: dog_bone.price, quantity: 1)

      ItemOrder.create(item: cookie, order: order, price: cookie.price, quantity: 7)
      ItemOrder.create(item: cookie, order: order_new, price: cookie.price, quantity: 3)


      ItemOrder.create(item: pants, order: order_new, price: pants.price, quantity: 8)
      ItemOrder.create(item: mug, order: order, price: mug.price, quantity: 5)
      ItemOrder.create(item: boot, order: order, price: boot.price, quantity: 4)
      ItemOrder.create(item: shirt, order: order_new, price: shirt.price, quantity: 2)
      ItemOrder.create(item: hat, order: order_new, price: hat.price, quantity: 1)
      items = Item.by_popularity(5, "DESC")

      expect(items.length).to eq(5)
      expect(items.first.quantity).to eq(12)
      expect(items[1].quantity).to eq(10)
      expect(items[2].quantity).to eq(8)
      expect(items[3].quantity).to eq(5)
      expect(items.last.quantity).to eq(4)
    end

    it 'can find bottom five selling items' do
      user = create(:regular_user)
      order = create(:random_order, user: user)
      order_new = create(:random_order, user: user)

      dog_bone = create(:random_item)
      mug = create(:random_item)
      boot = create(:random_item)
      shirt = create(:random_item)
      hat = create(:random_item)
      cookie = create(:random_item)
      pants = create(:random_item)

      ItemOrder.create(item: dog_bone, order: order, price: dog_bone.price, quantity: 9)
      ItemOrder.create(item: dog_bone, order: order_new, price: dog_bone.price, quantity: 2)
      ItemOrder.create(item: dog_bone, order: order_new, price: dog_bone.price, quantity: 1)

      ItemOrder.create(item: cookie, order: order, price: cookie.price, quantity: 7)
      ItemOrder.create(item: cookie, order: order_new, price: cookie.price, quantity: 3)


      ItemOrder.create(item: pants, order: order_new, price: pants.price, quantity: 8)
      ItemOrder.create(item: mug, order: order, price: mug.price, quantity: 5)
      ItemOrder.create(item: boot, order: order, price: boot.price, quantity: 4)
      ItemOrder.create(item: shirt, order: order_new, price: shirt.price, quantity: 2)
      ItemOrder.create(item: hat, order: order_new, price: hat.price, quantity: 1)
      items = Item.by_popularity(5, "ASC")

      expect(items.length).to eq(5)
      expect(items.first.quantity).to eq(0)
      expect(items[1].quantity).to eq(1)
      expect(items[2].quantity).to eq(2)
      expect(items[3].quantity).to eq(4)
      expect(items.last.quantity).to eq(5)
    end
  end
end
