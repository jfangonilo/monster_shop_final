require 'rails_helper'

RSpec.describe "it shows all orders on admin dash" do
  it "shows orders" do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @regular_user = User.create(name: "Boo",
                               address: "123 Main",
                               city: "Broomfield",
                               state: "CO",
                               zip: 80020,
                               email: "gooble@foogle.com",
                               password: "notsecure123")
     @other_user = User.create(name: "Carl",
                                address: "3 Block St",
                                city: "Buffalo",
                                state: "NY",
                                zip: 85550,
                                email: "nom@food.com",
                                password: "securething")
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @gavin = create(:admin_user)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    @order = @regular_user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    @order.item_orders.create!(item: @paper, price: @paper.price, quantity: 2)
    @order.item_orders.create!(item: @pencil, price: @pencil.price, quantity: 3)
    @order2 = @other_user.orders.create!(name: 'Jim', address: '123 Down Ave', city: 'Katy', state: 'TX', zip: 78733)
    @order2.item_orders.create!(item: @tire, price: @tire.price, quantity: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@gavin)

    visit "/admin"
    within "#order-#{@order.id}" do
      expect(page).to have_link(@order.user.name)
      expect(page).to have_content("Order ID: #{@order.id}")
      expect(page).to have_content("Created: #{@order.created_at}")
    end
    within "#order-#{@order2.id}" do
      expect(page).to have_link(@order2.user.name)
      expect(page).to have_content("Order ID: #{@order2.id}")
      expect(page).to have_content("Created: #{@order2.created_at}")
    end
  end
end
