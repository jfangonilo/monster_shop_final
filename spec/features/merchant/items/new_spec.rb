require 'rails_helper'

RSpec.describe "As a merchant", type: :feature do
  describe "when I visit my items page and I see a link to add a new item" do
    before :each do
      @merchant = create(:jomah_merchant)
      @merchant_employee = create(:merchant_employee, merchant: @merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    end

    it "can click on that link to add a new item" do
        visit merchant_dash_items_path
        click_on "Add New Item"
        expect(current_path).to eq(new_merchant_dash_item_path)

        name = "Chamois Buttr"
        price = 18
        description = "No more chaffin'!"
        image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
        inventory = 25

        fill_in "Name", with: name
        fill_in "Price", with: price
        fill_in "Description", with: description
        fill_in "Image", with: image_url
        fill_in "Inventory", with: inventory

        click_button "Create Item"

        new_item = Item.last

        expect(current_path).to eq(merchant_dash_items_path)
        expect(new_item.name).to eq(name)
        expect(Item.last.active?).to be(true)
        expect(page).to have_content(name)
        expect(page).to have_css("img[src*='#{new_item.image}']")
    end

    it "will have all item details and only image can be blank" do
      visit merchant_dash_items_path
      click_on "Add New Item"
      expect(current_path).to eq(new_merchant_dash_item_path)

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      inventory = 25

      fill_in "Name", with: name
      fill_in "Price", with: price
      fill_in "Description", with: description
      fill_in "Inventory", with: inventory

      click_button "Create Item"

      new_item = Item.last

      expect(current_path).to eq(merchant_dash_items_path)
      expect(new_item.name).to eq(name)
      expect(Item.last.active?).to be(true)
      expect(page).to have_content(name)
      expect(page).to have_css("img[src*='#{new_item.image}']")
    end
    it "will have a price greater than 0 and quantity 0 or greater" do
      visit merchant_dash_items_path
      click_on "Add New Item"
      expect(current_path).to eq(new_merchant_dash_item_path)

      name = "Chamois Buttr"
      price = 0
      description = "No more chaffin'!"
      inventory = 0

      fill_in "Name", with: name
      fill_in "Price", with: price
      fill_in "Description", with: description
      fill_in "Inventory", with: inventory

      click_button "Create Item"
      expect(page).to have_content("Inventory must be greater than 0")
      expect(page).to have_content("Price must be greater than 0")
    end
    it "a merchant employee will not be able to add a new item from another shop" do
      ray = create(:ray_merchant)
      chain = create(:random_item, name: "chain", merchant: ray)
      tire = create(:random_item, merchant: ray)

      visit "merchants/#{ray.id}/items"
      expect(page).not_to have_link("Add New Item")
    end
  end
end
