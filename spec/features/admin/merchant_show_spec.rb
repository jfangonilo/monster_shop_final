require 'rails_helper'
RSpec.describe "admin mechant show page" do
  it "sees everything that merchant would see" do
     user = create(:admin_user)
     ray = create(:ray_merchant)
     merchant = create(:jomah_merchant)
     item = create(:random_item, merchant: ray)
     order = create(:random_order, user: user)
     create(:item_order, item: item, order: order, price: item.price)

     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

     visit "/merchants"
     click_on "#{ray.name}"
     expect(current_path).to eq("/admin/merchants/#{ray.id}")
     expect(page).to have_content(ray.name)
     expect(page).to have_content(ray.address)
     expect(page).to have_content(ray.city)
     expect(page).to have_content(ray.state)
     expect(page).to have_content(ray.zip)
     expect(page).to have_link("All #{ray.name} Items")

     within "#order-#{order.id}" do
       expect(page).to have_link("#{order.id}")
       expect(page).to have_content(order.created_at)
       expect(page).to have_content(order.quantity_ordered_from(ray))
       expect(page).to have_content(number_to_currency(order.subtotal_from(ray)/100.to_f))
     end
  end
  it "shows a button to enable or disable merchant" do
    user = create(:admin_user)
    ray = create(:ray_merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/admin/merchants"
    within "#merchant-#{ray.id}" do
      expect(page).to have_button("Disable")
      expect(page).not_to have_button("Enable")
      click_on "Disable"
    end
    expect(current_path).to eq("/admin/merchants")
    within "#merchant-#{ray.id}" do
      expect(page).not_to have_button("Disable")
      expect(page).to have_button("Enable")
      click_on "Enable"
    end
  end
end
