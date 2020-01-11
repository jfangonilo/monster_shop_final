require 'rails_helper'

RSpec.describe "As an admin user" do
  before :each do
    @merchant = create(:jomah_merchant)
    @admin = create(:admin_user)
    @item_1 = create(:random_item, merchant: @merchant)
    @item_2 = create(:random_item, merchant: @merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe "the merchant items index page" do
    it 'has the ability to activate and deactivate items' do
      visit "/admin/merchants/#{@merchant.id}/items"
      within "#item-#{@item_1.id}" do
        click_link "Deactivate"
      end

      within "#item-#{@item_1.id}" do
        expect(page).not_to have_link "Deactivate"
        click_link "Activate"
      end

      within "#item-#{@item_1.id}" do
        expect(page).not_to have_link "Activate"
      end
    end

    it 'has the ability to add an item' do
      visit "/admin/merchants/#{@merchant.id}/items"
      click_link "Add New Item"

      expect(current_path).to eq("/admin/merchants/#{@merchant.id}/items/new")

      fill_in "Name", with: "fake Name"
      fill_in "Description", with: "fake Description"
      fill_in "Price", with: 12
      fill_in "Inventory", with: 12
      click_button "Create Item"

      item = Item.last
      expect(page).to have_content item.name
    end

    it 'flashes an error when entering bad data' do
      visit "/admin/merchants/#{@merchant.id}/items"
      click_link "Add New Item"

      fill_in "Name", with: ""
      fill_in "Description", with: ""
      fill_in "Price", with: "hello"
      fill_in "Inventory", with: "number"
      click_button "Create Item"

      expect(page).to have_button "Create Item"
    end

    it 'has the ability to edit items' do
      visit "/admin/merchants/#{@merchant.id}/items"

      within "#item-#{@item_1.id}" do
        click_link "Edit Item"
      end
      expect(current_path).to eq("/admin/merchants/#{@merchant.id}/items/#{@item_1.id}/edit")

      fill_in "Name", with: "fake Name"
      fill_in "Description", with: "fake Description"
      fill_in "Price", with: 12
      fill_in "Inventory", with: 12
      click_button "Update Item"

      expect(page).to have_content "fake Name"
    end

    it 'flashes an error for editing bad data' do
      visit "/admin/merchants/#{@merchant.id}/items"

      within "#item-#{@item_1.id}" do
        click_link "Edit Item"
      end

      fill_in "Name", with: ""
      fill_in "Description", with: ""
      fill_in "Price", with: "hello"
      fill_in "Inventory", with: "number"
      click_button "Update Item"

      expect(page).to have_button "Update Item"
    end

    it 'has the ability to delete items' do
      visit "/admin/merchants/#{@merchant.id}/items"
      within "#item-#{@item_1.id}" do
        click_link "Delete Item"
      end
      expect(page).not_to have_content @item_1.name
    end
  end
end