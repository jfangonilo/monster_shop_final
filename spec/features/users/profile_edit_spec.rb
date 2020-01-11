require 'rails_helper'

RSpec.describe "edit user info" do
  it "has an edit page with prepoulated data" do

    regular_user = User.create!(name: "Becky",
                               address: "123 Main",
                               city: "Broomfield",
                               state: "CO",
                               zip: 80020,
                               email: "go@foogle.com",
                               password: "notsecure123")
    this_regular_user = User.create!(name: "Jimmy",
                              address: "3 Bronco Rd",
                              city: "Hye",
                              state: "TX",
                              zip: 78737,
                              email: "j@c.com",
                              password: "mypassword")

    visit '/merchants'
    click_on 'Log In'

    expect(current_path).to eq("/login")
    fill_in :email, with: "go@foogle.com"
    fill_in :password, with: "notsecure123"
    click_button "Log In"

    expect(current_path).to eq("/profile")
    click_link "Edit Your Profile"

    expect(current_path).to eq("/profile/edit")

    fill_in :name, with: "Sigourney Weaver"
    fill_in :address, with: "666 Meyers Lane"
    click_button "Submit"

    expect(page).to have_content("Sigourney Weaver")
    expect(page).to have_content("666 Meyers Lane")
    expect(page).to have_content(regular_user.city)
    expect(page).to have_content(regular_user.state)
    expect(page).to have_content(regular_user.zip)
    expect(page).to have_content(regular_user.email)

    click_link "Log Out"
    click_link "Log In"

    fill_in :email, with: this_regular_user.email
    fill_in :password, with: this_regular_user.password
    click_button "Log In"

    expect(page).to have_content(this_regular_user.name)
    expect(page).to have_content(this_regular_user.address)
    expect(page).to have_content(this_regular_user.city)
    expect(page).to have_content(this_regular_user.state)
    expect(page).to have_content(this_regular_user.zip)
    expect(page).to have_content(this_regular_user.email)
  end

  it "has an edit page with prepoulated data" do
    this_regular_user = User.create!(name: "Jimmy",
                              address: "3 Bronco Rd",
                              city: "Hye",
                              state: "TX",
                              zip: 78737,
                              email: "explain@c.com",
                              password: "mypassword")

    walter = User.create!(name: "Walter White",
                               address: "7 RR 12",
                               city: "Dripping Springs",
                               state: "TX",
                               zip: 78620,
                               email: "fake@someplace.com",
                               password: "MangosAreTrash")


    visit '/merchants'
    click_on 'Log In'

    expect(current_path).to eq("/login")

    fill_in :email, with: walter.email
    fill_in :password, with: walter.password
    click_button "Log In"

    expect(current_path).to eq("/profile")
    click_link "Edit Your Profile"

    expect(current_path).to eq("/profile/edit")

    fill_in :email, with: this_regular_user.email
    click_button "Submit"

    expect(page).to have_content("Email has already been taken")
    expect(current_path).to eq("/profile/edit")

    fill_in :email, with: "enjoy@nothing.com"
    click_button "Submit"

    expect(page).to have_content(walter.name)
    expect(page).to have_content(walter.address)
    expect(page).to have_content(walter.city)
    expect(page).to have_content(walter.state)
    expect(page).to have_content(walter.zip)
    expect(page).to have_content("enjoy@nothing.com")

    click_link "Log Out"

    click_link "Log In"
    fill_in :email, with: "enjoy@nothing.com"
    fill_in :password, with: walter.password
    click_button "Log In"
    expect(page).to have_content("You are logged in as #{walter.name}")
  end
end
