require 'rails_helper'

RSpec.describe "As an admin user", type: :feature do
  describe "When I visit the user index page" do
    before :each do
      @admin_user = create(:admin_user)
      @user_1 = create(:random_user)
      @user_2 = create(:random_user)
      @user_3 = create(:random_user)
      @merchant_employee = create(:merchant_employee)

    end
    it "I see a disable/enable button next to any user" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
      visit "/admin/users"
      within "#user-#{@user_1.id}" do
        expect(page).to have_content(@user_1.name)
        expect(@user_1.active).to eq(true)
        expect(page).to have_link("Deactivate User")
      end

      within "#user-#{@user_2.id}" do
        expect(page).to have_content(@user_2.name)
        expect(@user_2.active).to eq(true)
        expect(page).to have_link("Deactivate User")
      end

      within "#user-#{@user_3.id}" do
        expect(page).to have_content(@user_3.name)
        expect(@user_3.active).to eq(true)
        expect(page).to have_link("Deactivate User")
      end
    end
    it "When I click on the button it will update user status and redirect badck to user index page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
      visit "/admin/users"
      within "#user-#{@user_1.id}" do
        click_on "Deactivate User"
        @user_1.reload
        expect(current_path).to eq("/admin/users")
        expect(page).to have_link("Activate User")
        expect(@user_1.active).to eq(false)
        click_on "Activate User"
        @user_1.reload
        expect(@user_1.active).to eq(true)
        expect(page).to have_link("Deactivate User")
      end
      within "#user-#{@user_2.id}" do
        expect(page).to have_content(@user_2.name)
        expect(@user_2.active).to eq(true)
        expect(page).to have_link("Deactivate User")
      end
      within "#user-#{@user_3.id}" do
        expect(page).to have_content(@user_3.name)
        expect(@user_3.active).to eq(true)
        expect(page).to have_link("Deactivate User")
      end
    end
    it "I see a flash message that account status is updated" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
      visit "/admin/users"
      within "#user-#{@user_1.id}" do
        click_on "Deactivate User"
        @user_1.reload
        expect(@user_1.active).to eq(false)
      end
      expect(page).to have_content("#{@user_1.name} has been disabled.")

      within "#user-#{@user_1.id}" do
        click_on "Activate User"
        @user_1.reload
        expect(@user_1.active).to eq(true)
      end
      expect(page).to have_content("#{@user_1.name} has been enabled.")
    end

    it "If a user is disabled they cannot login" do
      regular_user = User.create!(name: "Becky",
                                 address: "123 Main",
                                 city: "Broomfield",
                                 state: "CO",
                                 zip: 80020,
                                 email: "go@foogle.com",
                                 password: "notsecure123",
                                 role: 0,
                                 active: false)

      visit '/merchants'
      click_on 'Log In'

      expect(current_path).to eq("/login")

      fill_in :email, with: "go@foogle.com"
      fill_in :password, with: "notsecure123"
      click_button "Log In"
      expect(page).to have_content("Sorry This Acount Is Inactive")
    end
    it "if user is disabledcity/state should not be part of statistics" do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      user = create(:regular_user)
      user_2 = create(:random_user)
      user_3 = create(:random_user)
      user_4 = create(:random_user, active: false)
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = user.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_3 = user.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033)

      order_4 = user_4.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_5 = user_4.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_6 = user_4.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033)

      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_4.item_orders.create(item:@tire, price: @tire.price, quantity: 1)
      order_5.item_orders.create(item:@tire, price: @tire.price, quantity: 1)
      order_6.item_orders.create(item:@tire, price: @tire.price, quantity: 1)

      expect(@meg.distinct_cities).to match_array(["Denver","Hershey"])
    end
  end
end
