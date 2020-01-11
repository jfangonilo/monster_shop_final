require 'rails_helper'

describe "merchant dashboard" do
  it "should show the merchant user's info" do
    merchant_employee = create(:merchant_employee)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

    visit "/merchant"
    expect(page).to have_content merchant_employee.merchant.name
    expect(page).to have_content merchant_employee.merchant.address
    expect(page).to have_content merchant_employee.merchant.city
    expect(page).to have_content merchant_employee.merchant.state
    expect(page).to have_content merchant_employee.merchant.zip
  end

  describe "setting up orders" do
    before :each do
        @merchant_shop = create(:jomah_merchant)
        @merchant = create(:merchant_employee, merchant_id: @merchant_shop.id)
        @item_1 = create(:random_item, merchant_id: @merchant_shop.id )
        @item_2 = create(:random_item, merchant_id: @merchant_shop.id)
        @item_3 = create(:random_item, merchant_id: @merchant_shop.id)
        @item_4 = create(:random_item, merchant_id: @merchant_shop.id)
        @regular_user = create(:regular_user)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)

        visit "/items/#{@item_1.id}"
        click_on "Add To Cart"
        visit "/items/#{@item_2.id}"
        click_on "Add To Cart"
        visit "/cart"
        click_on "Checkout"
        fill_in 'Name', with: @regular_user.name
        fill_in 'Address', with: @regular_user.address
        fill_in 'City', with: @regular_user.city
        fill_in 'State', with: @regular_user.state
        fill_in 'Zip', with: @regular_user.zip

        click_on "Create Order"

        visit "/items/#{@item_3.id}"
        click_on "Add To Cart"
        visit "/items/#{@item_4.id}"
        click_on "Add To Cart"
        visit "/cart"
        click_on "Checkout"

        fill_in 'Name', with: @regular_user.name
        fill_in 'Address', with: @regular_user.address
        fill_in 'City', with: @regular_user.city
        fill_in 'State', with: @regular_user.state
        fill_in 'Zip', with: @regular_user.zip
        click_on "Create Order"
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      end

      it "if a user has pending orders containing items I sell I see a list of those orders" do
        visit "/merchant"
        order_1 = @merchant.merchant.item_orders.first.order
        order_2 = @merchant.merchant.item_orders.last.order
        @merchant.merchant.pending_orders
        items_1 = order_1.items
        items_2 = order_2.items

        within("#order-#{order_1.id}") do
          expect(page).to have_link("Order ID: #{order_1.id}")
          expect(page).to have_content(order_1.created_at)
          expect(page).to have_content(items_1.size)
          expect(page).to have_content(number_to_currency(order_1.grandtotal/100.to_f))
        end

        within("#order-#{order_2.id}") do
          expect(page).to have_link("Order ID: #{order_2.id}")
          expect(page).to have_content(order_2.created_at)
          expect(page).to have_content(items_2.size)
          expect(page).to have_content(number_to_currency(order_2.grandtotal/100.to_f))
          click_on "#{order_2.id}"
          expect(current_path).to eq("/merchant/orders/#{order_2.id}")
        end
      end

      it "the order list includes order_id which is link to order show page, date created, total quantity of my items and total value for that order " do
      end
  end
end
