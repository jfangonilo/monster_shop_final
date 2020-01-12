require 'rails_helper'

RSpec.describe "As a merchant user" do
  before :each do
    @merchant = create(:jomah_merchant)
    merchant_user = create(:merchant_employee, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)
  end

  describe "new coupon page" do
    it "can create a new coupon" do
      visit "/merchant/coupons/new"

      fill_in "Name", with: "Coupon Name"
      fill_in "Code", with: "CODE34"
      select "0.34", from: "Percent off"

      click_button "Create Coupon"

      coupon = Coupon.last
      expect(coupon.name).to eq "Coupon Name"
      expect(coupon.code).to eq "CODE34"
      expect(coupon.percent_off).to eq(0.34)

      expect(page).to have_content "New Coupon Created"
      expect(current_path).to eq "/merchant/coupons"
    end

    it "doesn't create a coupon with bad data" do
      visit "/merchant/coupons/new"
      click_button "Create Coupon"

      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Code can't be blank"
      expect(page).to have_button "Create Coupon"
    end
  end
end