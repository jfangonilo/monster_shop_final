require 'rails_helper'

RSpec.describe "As a merchant user" do
  before :each do
    @merchant = create(:jomah_merchant)
    @coupon_1 = create(:coupon_1, merchant: @merchant)
    @coupon_2 = create(:coupon_2, merchant: @merchant)
    merchant_user = create(:merchant_employee, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)

    visit "/merchant/coupons"
  end

  describe "the coupon index page" do
    it "can be accessed from the nav bar" do
      visit "/"
      within ".topnav" do
        click_link "All Coupons"
      end

      expect(current_path).to eq "/merchant/coupons"
    end

    it "shows the merchant's coupons" do
      within "#coupon-#{@coupon_1.id}" do
        expect(page).to have_link @coupon_1.name
        expect(page).to have_content @coupon_1.code
        expect(page).to have_content @coupon_1.percent_off
        expect(page).to have_content "Active"
      end

      within "#coupon-#{@coupon_2.id}" do
        expect(page).to have_link @coupon_2.name
        expect(page).to have_content @coupon_2.code
        expect(page).to have_content @coupon_2.percent_off
        expect(page).to have_content "Active"
      end
    end

    it "has a link to the coupon show page" do
      click_link @coupon_1.name
      expect(current_path).to eq("/merchant/coupons/#{@coupon_1.id}")
    end

    it "has a link to create a new coupon" do
      click_link "New Coupon"
      expect(current_path).to eq("/merchant/coupons/new")
    end

  end
end