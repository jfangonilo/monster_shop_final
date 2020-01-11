require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end

    it "can show merchant items index" do
      regular_user = User.create(name: "Becky",
                                 address: "123 Main",
                                 city: "Broomfield",
                                 state: "CO",
                                 zip: 80020,
                                 email: "goble@foogle.com",
                                 password: "notsecure123",
                                 role: 1,
                                merchant_id: @bike_shop.id)
      visit "/"
      click_link "Log In"
      fill_in :email, with: regular_user.email
      fill_in :password, with: regular_user.password
      click_button "Log In"

      visit '/merchant'
      click_link "All #{@bike_shop.name} Items"
      expect(current_path).to eq('/merchant/items')
    end
  end
end
