require 'rails_helper'

describe "user navigation" do
  it "restricts access to visitors" do
    visit merchant_dash_path
    expect(page.status_code).to eq(404)

    visit admin_dash_path
    expect(page.status_code).to eq(404)

    visit profile_path
    expect(page.status_code).to eq(404)
  end

  it "restricts users from accessing /merchant and /admin" do
    user = create(:regular_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit merchant_dash_path
    expect(page.status_code).to eq(404)

    visit admin_dash_path
    expect(page.status_code).to eq(404)
  end

  it "restricts merchants from accessing /admin" do
    merchant = create(:merchant_employee)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

    visit admin_dash_path
    expect(page.status_code).to eq(404)

    merchant_admin = create(:merchant_admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit admin_dash_path
    expect(page.status_code).to eq(404)
  end

  it "restricts admins from accessing /merchant and /cart" do
    admin = create(:admin_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit merchant_dash_path
    expect(page.status_code).to eq(404)

    visit cart_path
    expect(page.status_code).to eq(404)
  end
end