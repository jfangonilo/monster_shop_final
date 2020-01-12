require 'rails_helper'

RSpec.describe "As a merchant user" do
  before :each do
    @merchant = create(:jomah_merchant)
    @coupon_1 = create(:coupon_1, merchant: @merchant)
    @coupon_2 = create(:coupon_2, merchant: @merchant)
    @order = create(:random_order, coupon: @coupon_2)
    merchant_user = create(:merchant_employee, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)
  end

  describe "the coupon show page" do
    it "shows the coupon's info" do
      visit "/merchant/coupons/#{@coupon_1.id}"
      expect(page).to have_content @coupon_1.name
      expect(page).to have_content @coupon_1.code
      expect(page).to have_content @coupon_1.percent_off
      expect(page).to have_content "Active"
    end

    it "has a link to edit the coupon" do
      visit "/merchant/coupons/#{@coupon_1.id}"
      click_link "Edit Coupon"
      expect(current_path).to eq "/merchant/coupons/#{@coupon_1.id}/edit"
    end

    it "has a button to delete the coupon" do
      visit "/merchant/coupons/#{@coupon_1.id}"
      expect(page).to have_button "Delete Coupon"
    end

    it "only allows me to delete a coupon w/o any orders" do
      visit "/merchant/coupons/#{@coupon_2.id}"
      expect(page).not_to have_button "Delete Coupon"

      visit "/merchant/coupons/#{@coupon_1.id}"
      click_button "Delete Coupon"

      expect(page).to have_content "Coupon Deleted"
      expect(current_path).to eq "/merchant/coupons"
      expect(page).not_to have_content @coupon_1.name
    end
  end
end