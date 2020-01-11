require 'rails_helper'

RSpec.describe "As an admin user" do
  before :each do
    @merchant = create(:jomah_merchant)
    @admin = create(:admin_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  describe "the merchants profile show page" do
    it "has a link to the merchants items" do
      visit "/admin/merchants/#{@merchant.id}"
      click_link "All #{@merchant.name} Items"
      expect(current_path).to eq "/admin/merchants/#{@merchant.id}/items"
    end
  end
end
