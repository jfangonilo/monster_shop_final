require 'rails_helper'

RSpec.describe "As a visitor" do
  before :each do
    @merchant = create(:jomah_merchant)
    @coupon_1 = create(:coupon_1, merchant: @merchant)
    @coupon_2 = create(:coupon_2, merchant: @merchant)
    user = create(:random_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "I can add a coupon code at the checkout page" do
    visit '/cart'

    fill_in "Coupon", with: "50OFF"
    expect(page).to have_button "Apply Coupon"
  end
end