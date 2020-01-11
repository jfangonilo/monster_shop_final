require 'rails_helper'

RSpec.describe "user profile show page" do
  it "shows the user's profile page with info" do
    regular_user = User.create!(name: "Becky",
                               address: "123 Main",
                               city: "Broomfield",
                               state: "CO",
                               zip: 80020,
                               email: "go@foogle.com",
                               password: "notsecure123")

    visit '/merchants'
    click_on 'Log In'

    expect(current_path).to eq("/login")

    fill_in :email, with: "go@foogle.com"
    fill_in :password, with: "notsecure123"
    click_button "Log In"

    expect(current_path).to eq("/profile")

    expect(page).to have_content("Welcome go@foogle.com")
    expect(page).to have_content(regular_user.name)
    expect(page).to have_content(regular_user.address)
    expect(page).to have_content(regular_user.city)
    expect(page).to have_content(regular_user.state)
    expect(page).to have_content(regular_user.zip)
    expect(page).to have_content(regular_user.email)
    expect(page).to have_link("Edit Your Profile")
  end
end
