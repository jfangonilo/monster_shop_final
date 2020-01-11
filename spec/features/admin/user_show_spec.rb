require 'rails_helper'

describe "admin user show page" do
  it "shows a user's data" do
    user = create(:random_user)
    admin = create(:admin_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/users/#{user.id}"
    expect(page).to have_content user.name
    expect(page).to have_content user.address
    expect(page).to have_content user.city
    expect(page).to have_content user.state
    expect(page).to have_content user.zip
  end
end