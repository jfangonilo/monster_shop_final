require 'rails_helper'

RSpec.describe 'merchant item delete', type: :feature do
  describe 'when I visit an merchant items show page' do
    it 'I can delete a merchants item' do
      merchant = create(:jomah_merchant)
      merchant_employee = create(:merchant_employee, merchant: merchant)

      chain = create(:random_item, name: "chain", merchant: merchant)
      tire = create(:random_item, merchant: merchant)
      roof_rack = create(:random_item, merchant: merchant)
      boots = create(:random_item, merchant: merchant)
      sled = create(:random_item, merchant: merchant)
      skis = create(:random_item, merchant: merchant)
      items = [chain, tire, roof_rack, boots, sled]

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit "/merchant/items"

        within "#item-#{chain.id}" do
          expect(page).to have_content(chain.name)
          expect(page).to have_link("Delete Item")
          click_on "Delete Item"
          expect(current_path).to eq("/merchant/items")
        end
        within "#item-#{roof_rack.id}" do
          expect(page).to have_content(roof_rack.name)
          expect(page).to have_link("Delete Item")
          click_on "Delete Item"
          expect(current_path).to eq("/merchant/items")
        end
        within "#item-#{boots.id}" do
          expect(page).to have_content(boots.name)
          expect(page).to have_link("Delete Item")
          click_on "Delete Item"
          expect(current_path).to eq("/merchant/items")
        end

      expect(page).to_not have_content(chain.name)
      expect(page).to have_content(skis.name)
      expect(page).to_not have_content(roof_rack.name)
      expect(page).to_not have_content(boots.name)
      expect(page).to have_content(sled.name)
      expect(page).to have_content(tire.name)
      expect(page).to have_content("Item Deleted")
    end

    it 'I can delete items and it deletes reviews' do
      merchant = create(:jomah_merchant)
      merchant_employee = create(:merchant_employee, merchant: merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      chain = create(:random_item, name: "chain", merchant: merchant)
      review_1 = chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)

      visit "/merchant/items"

      click_on "Delete Item"
      expect(Review.where(id:review_1.id)).to be_empty
    end

    it 'I can not delete items with orders' do
      user = create(:regular_user)
      merchant = create(:jomah_merchant)
      merchant_employee = create(:merchant_employee, merchant: merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      chain = create(:random_item, name: "chain", merchant: merchant)
      review_1 = chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218)
      order_1.item_orders.create!(item: chain, price: chain.price, quantity: 2)

      visit "/merchant/items"

      within "#item-#{chain.id}" do
        expect(page).to_not have_link("Delete Item")
      end
    end

    it "a merchant employee will not be able to delete an item from another shop" do
      ray = create(:ray_merchant)
      merchant = create(:jomah_merchant)
      merchant_employee = create(:merchant_employee, merchant: merchant)

      chain = create(:random_item, name: "chain", merchant: ray)
      tire = create(:random_item, merchant: ray)
      roof_rack = create(:random_item, merchant: ray)
      boots = create(:random_item, merchant: merchant)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit "merchants/#{ray.id}/items"
      expect(page).not_to have_link("Delete Item")
    end
  end
end
