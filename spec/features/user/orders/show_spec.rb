require "rails_helper"

RSpec.describe "order show page" do
  it "shows an order show page" do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @regular_user = User.create(name: "Boo",
                               address: "123 Main",
                               city: "Broomfield",
                               state: "CO",
                               zip: 80020,
                               email: "gooble@foogle.com",
                               password: "notsecure123")
     visit '/'
     click_on 'Log In'
     expect(current_path).to eq("/login")
     fill_in :email, with: "gooble@foogle.com"
     fill_in :password, with: "notsecure123"
     click_button "Log In"

     @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
     @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
     @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
     @order = @regular_user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
     @order.item_orders.create!(item: @paper, price: @paper.price, quantity: 2)
     @order.item_orders.create!(item: @pencil, price: @pencil.price, quantity: 3)
     visit "/profile"
     click_link "My Orders"
     expect(current_path).to eq("/profile/orders")

     within "#order-#{@order.id}" do
       click_link "Order ID: #{@order.id}"
     end
     expect(current_path).to eq("/profile/orders/#{@order.id}")

     expect(page).to have_content("Order ID: #{@order.id}")
     expect(page).to have_content(@order.created_at)
     expect(page).to have_content(@order.updated_at)
     expect(page).to have_content(@order.status.capitalize)
     within "#item-#{@pencil.id}" do
      expect(page).to have_content(@pencil.name)
      expect(page).to have_content(@pencil.description)
      expect(page).to have_css("img[src*='#{@pencil.image}']")
      expect(page).to have_content("3")
      expect(page).to have_content("$0.06")
    end
    within "#item-#{@paper.id}" do
      expect(page).to have_content(@paper.name)
      expect(page).to have_content(@paper.description)
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_content("2")
      expect(page).to have_content("$0.40")
    end
     expect(page).to have_content("Total Quantity Ordered: 5")
     expect(page).to have_content("Total: $0.46")
  end

  it "allows me to cancel orders" do
    user = create(:regular_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    merchant = create(:jomah_merchant)
    items = create_list(:random_item, 5, merchant: merchant, inventory: 10)
    order = create(:random_order, user: user)
    items.each do |item|
      create(:item_order, order: order, item: item, price: item.price, quantity: 5)
    end

    visit "/profile/orders/#{order.id}"
    within "#order-cancel" do
      click_button "Cancel Order"
    end
    expect(current_path).to eq profile_path
    expect(page).to have_content "Order Cancelled"

    visit "/profile/orders/#{order.id}"
    within "#order-status" do
      expect(page).to have_content "Cancelled"
    end
  end

  it "doesn't allow me to cancel an order with a status of shipped" do
    user = create(:regular_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    merchant = create(:jomah_merchant)
    items = create_list(:random_item, 5, merchant: merchant, inventory: 10)
    order = create(:random_order, user: user, status: "shipped")
    items.each do |item|
      create(:item_order, order: order, item: item, price: item.price, quantity: 5)
    end

    visit "/profile/orders/#{order.id}"
    within "#order-cancel" do
      expect(page).not_to have_button "Cancel Order"
    end
  end
end
