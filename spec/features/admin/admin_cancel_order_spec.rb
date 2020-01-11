require 'rails_helper'
RSpec.describe "on user order show page" do
  it "can cancel order of a user" do
    user = create(:admin_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    merchant = create(:jomah_merchant)
    items = create_list(:random_item, 5, merchant: merchant, inventory: 10)
    order = create(:random_order, user: user)
    items.each do |item|
      create(:item_order, order: order, item: item, price: item.price, quantity: 5)
    end

    visit "/admin/users/#{user.id}/orders/#{order.id}"
    within "#order-cancel" do
      click_button "Cancel Order"
    end
    expect(current_path).to eq "/admin/users/#{user.id}/orders/#{order.id}"
    expect(page).to have_content "Order Cancelled"

    within "#order-status" do
      expect(page).to have_content "Cancelled"
    end
  end
end