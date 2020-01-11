require 'rails_helper'
RSpec.describe "disabling merchant disables items" do
  it "disables items also" do
    customer = create(:regular_user)
    user = create(:admin_user)
    ray = create(:ray_merchant)
    merchant = create(:jomah_merchant)
    item1 = create(:random_item, merchant: ray)
    item2 = create(:random_item, merchant: ray)
    item3 = create(:random_item, merchant: ray)
    item4 = create(:random_item, merchant: ray)
    item5 = create(:random_item, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/admin/merchants"
    within "#merchant-#{ray.id}" do
      click_button "Disable"
    end
    click_on "Log Out"

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(customer)
    visit "/items"
    expect(page).not_to have_content(item1.name)
    expect(page).not_to have_content(item2.name)
    expect(page).not_to have_content(item3.name)
    expect(page).not_to have_content(item4.name)
    expect(page).to have_content(item5.name)

    click_on "Log Out"

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/admin/merchants"
    within "#merchant-#{ray.id}" do
      click_button "Enable"
    end
    click_on "Log Out"

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(customer)
    visit "/items"
    expect(page).to have_content(item1.name)
    expect(page).to have_content(item2.name)
    expect(page).to have_content(item3.name)
    expect(page).to have_content(item4.name)
    expect(page).to have_content(item5.name)
  end
end
