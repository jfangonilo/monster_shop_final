require 'rails_helper'

RSpec.describe "As a visitor" do
  before :each do
    @merchant_1 = create(:jomah_merchant)
    @item_1 = create(:random_item, price: 100_12, merchant: @merchant_1)
    @item_2 = create(:random_item, price: 50_13, merchant: @merchant_1)
    @item_3 = create(:random_item, price: 25_00, merchant: @merchant_1)

    @merchant_2 = create(:ray_merchant)
    @item_4 = create(:random_item, merchant: @merchant_2)
    @item_5 = create(:random_item, merchant: @merchant_2)
    @item_6 = create(:random_item, merchant: @merchant_2)

    @coupon_1 = create(:coupon_1, merchant: @merchant_1)
    @coupon_2 = create(:coupon_2, merchant: @merchant_2)

    user = create(:random_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/items/#{@item_1.id}"
    click_on "Add To Cart"
    visit "/items/#{@item_2.id}"
    click_on "Add To Cart"
    visit "/items/#{@item_3.id}"
    click_on "Add To Cart"
    visit "/items/#{@item_4.id}"
    click_on "Add To Cart"
    visit "/items/#{@item_5.id}"
    click_on "Add To Cart"
    visit "/items/#{@item_6.id}"
    click_on "Add To Cart"
  end

  it "I can add a coupon code at the checkout page" do
    visit '/cart'

    fill_in "Coupon", with: "50OFF"
    click_button "Apply Coupon"

    expect(page).to have_content "Coupon applied for #{@merchant_1.name} items"
    expect(current_path).to eq '/cart'
  end

  it "flashes a message for an invalid coupon" do
    visit '/cart'

    fill_in "Coupon", with: "100OFF"
    click_button "Apply Coupon"

    expect(page).to have_content "Invalid Coupon"
    expect(current_path).to eq '/cart'
  end

  it "I can see the total discount for items the coupon applies for" do
    visit '/cart'
    fill_in "Coupon", with: "50OFF"
    click_button "Apply Coupon"

    expect(page).to have_content "Coupon applied for #{@merchant_1.name} items"
    expect(current_path).to eq '/cart'

    within "#cart-item-#{@item_1.id}" do
      expect(page).to have_content "$50.06"
    end

    within "#cart-item-#{@item_2.id}" do
      expect(page).to have_content "$25.07"
    end

    within "#cart-item-#{@item_3.id}" do
      expect(page).to have_content "$12.50"
    end

    within "#cart-item-#{@item_4.id}" do
      expect(page).to have_content @item_4.price
    end

    within "#cart-item-#{@item_5.id}" do
      expect(page).to have_content @item_5.price
    end

    within "#cart-item-#{@item_6.id}" do
      expect(page).to have_content @item_6.price
    end
  end

  it "I can check out with the coupon code and see my discounts applied" do
    visit "/cart"
    fill_in "Coupon", with: "50OFF"
    click_button "Apply Coupon"
    click_link "Checkout"

    fill_in "Name", with: "fake Name"
    fill_in "Address", with: "fake Address"
    fill_in "City", with: "fake City"
    fill_in "State", with: "fake State"
    fill_in "Zip", with: 12345
    click_button "Create Order"

    order = Order.last
    expect(order.coupon_id).to eq @coupon_1.id
    expect(current_path).to eq "/profile/orders"
    click_link "Order ID: #{order.id}"

    expect(page).to have_content @coupon_1.name

    within "#item-#{@item_1.id}" do
      expect(page).to have_content "$50.06"
    end

    within "#item-#{@item_2.id}" do
      expect(page).to have_content "$25.07"
    end

    within "#item-#{@item_3.id}" do
      expect(page).to have_content "$12.50"
    end

    within "#item-#{@item_4.id}" do
      expect(page).to have_content @item_4.price
    end

    within "#item-#{@item_5.id}" do
      expect(page).to have_content @item_5.price
    end

    within "#item-#{@item_6.id}" do
      expect(page).to have_content @item_6.price
    end
  end
end