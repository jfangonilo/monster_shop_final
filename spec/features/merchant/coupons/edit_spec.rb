require 'rails_helper'

RSpec.describe "As a merchant user" do
  before :each do
    @merchant = create(:jomah_merchant)
    @coupon_1 = create(:coupon_1, merchant: @merchant)
    @coupon_2 = create(:coupon_2, merchant: @merchant)
    merchant_user = create(:merchant_employee, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)
  end

  describe "the coupon edit page" do
    it "allows me to edit the coupon's data" do
      visit "/merchant/coupons/#{@coupon_1.id}/edit"

      fill_in "Name", with: "Coupon Name"
      fill_in "Code", with: "CODE34"
      select "0.34", from: "Percent off"

      click_button "Update Coupon"

      @coupon_1.reload
      expect(@coupon_1.name).to eq "Coupon Name"
      expect(@coupon_1.code).to eq "CODE34"
      expect(@coupon_1.percent_off).to eq(0.34)

      expect(page).to have_content "Coupon Updated"
      expect(current_path).to eq "/merchant/coupons/#{@coupon_1.id}"
    end

    it "doesn't update a coupon with bad data" do
      visit "/merchant/coupons/#{@coupon_2.id}/edit"

      fill_in "Name", with: "   "
      fill_in "Code", with: "50OFF"
      click_button "Update Coupon"

      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Code has already been taken"
      expect(page).to have_button "Update Coupon"
    end
  end
end