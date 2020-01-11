require 'rails_helper'

describe "admin order dashboard" do
  it "shows packaged orders and can ship them" do
    user_1 = create(:random_user)
    user_2 = create(:random_user)
    user_3 = create(:random_user)
    user_4 = create(:random_user)
    admin_user = create(:admin_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

    merchant = create(:jomah_merchant)
    order_1 = create(:random_order, user: user_1, status: "pending")
    order_2 = create(:random_order, user: user_2, status: "packaged")
    order_3 = create(:random_order, user: user_3, status: "shipped")
    order_4 = create(:random_order, user: user_4, status: "cancelled")

    visit "/admin"

    within "#order-#{order_1.id}" do
      expect(page).not_to have_button "Ship Order"
    end
    within "#order-#{order_3.id}" do
      expect(page).not_to have_button "Ship Order"
    end
    within "#order-#{order_4.id}" do
      expect(page).not_to have_button "Ship Order"
    end

    within "#order-#{order_2.id}" do
      click_button "Ship Order"
    end

    within "#order-#{order_2.id}" do
      expect(page).to have_content "Status: Shipped"
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_2)

    visit "/profile/orders/#{order_2.id}"
    expect(page).not_to have_button "Cancel Order"
  end

  it "shows order id's as link to admin order show page" do
    user_1 = create(:random_user)
    user_2 = create(:random_user)
    admin_user = create(:admin_user)
    merchant = create(:jomah_merchant)
    order_1 = create(:random_order, user: user_1, status: "pending")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

    visit "/admin"

    within "#order-#{order_1.id}" do
      expect(page).to have_link(order_1.id)
      click_link "Order ID: #{order_1.id}"
    end
    expect(current_path).to eq("/admin/users/#{user_1.id}/orders/#{order_1.id}")
  end
end
