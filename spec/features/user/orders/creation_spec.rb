RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @user = create(:regular_user)
      visit "/login"

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button "Log In"

      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"
    end

    it 'I can create a new order' do
      visit "/cart"
      click_on "Checkout"

      fill_in :name, with: @user.name
      fill_in :address, with: @user.address
      fill_in :city, with: @user.city
      fill_in :state, with: @user.state
      fill_in :zip, with: @user.zip

      click_button "Create Order"

      new_order = Order.last

      expect(current_path).to eq "/profile/orders"
      visit "/profile/orders/#{new_order.id}"

      within '.shipping-address' do
        expect(page).to have_content(@user.name)
        expect(page).to have_content(@user.address)
        expect(page).to have_content(@user.city)
        expect(page).to have_content(@user.state)
        expect(page).to have_content(@user.zip)
      end

      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content(number_to_currency(@paper.price/100.to_f))
        expect(page).to have_content("2")
        expect(page).to have_content("$0.40")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content(number_to_currency(@tire.price/100.to_f))
        expect(page).to have_content("1")
        expect(page).to have_content("$1.00")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content(number_to_currency(@pencil.price/100.to_f))
        expect(page).to have_content("1")
        expect(page).to have_content("$0.02")
      end

      within "#grandtotal" do
        expect(page).to have_content("Total: $1.42")
      end

      within "#datecreated" do
        expect(page).to have_content(new_order.created_at)
      end
    end

    it "can't create order if info not filled out" do
      name = ""
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      expect(page).to have_content("Please complete address form to create an order.")
      expect(page).to have_button("Create Order")
    end
  end
end
