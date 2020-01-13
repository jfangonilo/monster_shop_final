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
end