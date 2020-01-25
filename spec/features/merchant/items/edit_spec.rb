require 'rails_helper'

RSpec.describe "As a merchant", type: :feature do
  describe "when I visit my items page and I see a link to edit an item" do
    before :each do
      @merchant = create(:jomah_merchant)
      @merchant_employee = create(:merchant_employee, merchant: @merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    end

    it "can click on that link to add a new item" do
        item = create(:random_item, merchant: @merchant)
        visit "/merchant/items"
        click_on "Edit Item"
        expect(current_path).to eq("/merchant/items/#{item.id}/edit")

        expect(find_field('Name').value).to eq item.name
        expect(find_field('Price').value).to eq item.price.to_s
        expect(find_field('Description').value).to eq item.description
        expect(find_field('Image').value).to eq item.image
        expect(find_field('Inventory').value).to eq item.inventory.to_s

        name = "Chamois Butter"
        price = 18
        description = "No more chaffin'!"
        image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
        inventory = 25

        fill_in "Name", with: "Chamois Butter"
        fill_in "Price", with: 18
        fill_in "Description", with: description
        fill_in "Image", with: image_url
        fill_in "Inventory", with: inventory

        click_button "Update Item"

        item.reload
        expect(current_path).to eq("/merchant/items")
        expect(item.name).to eq(name)
        expect(page).to have_content(name)
        expect(page).to have_css("img[src*='#{item.image}']")
    end

    it "will have all item details and only image can be blank" do
      item = create(:random_item, merchant: @merchant)
      visit "/merchant/items"
      click_on "Edit Item"
      expect(current_path).to eq("/merchant/items/#{item.id}/edit")

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      inventory = 25

      fill_in "Name", with: name
      fill_in "Price", with: price
      fill_in "Description", with: description
      fill_in "Inventory", with: inventory

      click_button "Update Item"


      item.reload
      expect(current_path).to eq("/merchant/items")
      expect(item.name).to eq(name)
      expect(page).to have_content(name)
      expect(page).to have_css("img[src*='#{item.image}']")
    end

    it "will have a price greater than 0 and quantity 0 or greater" do
      item = create(:random_item, merchant: @merchant)
      visit "/merchant/items"
      click_on "Edit Item"
      expect(current_path).to eq("/merchant/items/#{item.id}/edit")

      name = "Chamois Buttr"
      price = 0
      description = "No more chaffin'!"
      inventory = 0

      fill_in "Name", with: name
      fill_in "Price", with: price
      fill_in "Description", with: description
      fill_in "Inventory", with: inventory

      click_button "Update Item"

      expect(page).to have_content("Inventory must be greater than 0")
      expect(page).to have_content("Price must be greater than 0")
    end

    it "a merchant employee will not be able to add a new item from another shop" do
      ray = create(:ray_merchant)
      chain = create(:random_item, name: "chain", merchant: ray)
      tire = create(:random_item, merchant: ray)

      visit "merchants/#{ray.id}/items"
      expect(page).not_to have_link("Edit Item")
    end
  end
end
