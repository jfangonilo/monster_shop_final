require 'rails_helper'

RSpec.describe "create new users" do
  it "can create a new user" do
    visit '/merchants'
    click_on "Register"

    expect(current_path).to eq('/register')
    fill_in :name, with: "John Doe"
    fill_in :address, with: "42 West Street"
    fill_in :city, with: "Soloana"
    fill_in :state, with: "CA"
    fill_in :zip, with: 89897
    fill_in :email, with: "go@foogle.com"
    fill_in :password, with: "notsecure123"
    fill_in :password_confirmation, with: "notsecure123"
    click_button "Submit"

    new_user = User.last
    expect("#{new_user.name}").to eq("John Doe")
    expect(new_user.user?).to eq(true)

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Congratulations! You are now registered and logged in.")
  end

  it "won't work with incomplete information" do
    visit '/merchants'
    click_on "Register"

    expect(current_path).to eq('/register')
    fill_in :name, with: "Jan Doe"
    fill_in :address, with: "42 West Street"
    fill_in :city, with: "Soloana"
    fill_in :zip, with: 89897
    fill_in :email, with: "goggle@foogle.com"
    fill_in :password, with: "sure123"
    fill_in :password_confirmation, with: "sure123"
    click_button "Submit"


    expect(current_path).to eq('/register')
    expect(page).to have_content("State can't be blank")
  end

  it "won't work with mismatched passwords" do
    visit '/merchants'
    click_on "Register"

    expect(current_path).to eq('/register')
    fill_in :name, with: "Steve Doe"
    fill_in :address, with: "42 West Street"
    fill_in :city, with: "Soloana"
    fill_in :state, with: "CA"
    fill_in :zip, with: 89897
    fill_in :email, with: "goggle@foogle.com"
    fill_in :password, with: "notsosure123"
    fill_in :password_confirmation, with: "sure123"
    click_button "Submit"

    expect(current_path).to eq('/register')
    expect(page).to have_content("Password confirmation doesn't match Password")
    find_field :name, with: 'Steve Doe'
    find_field :address, with: "42 West Street"
    find_field :city, with: 'Soloana'
    find_field :state, with: "CA"
    find_field :zip, with: 89897
    find_field('email').value.blank?
    find_field('password').value.blank?
    find_field('password_confirmation').value.blank?
  end

  it "won't work with a used email address" do
    new_user = User.create!(name: "Jon Doe", address: "2233 South Street", city: "Solna", state: "CA", zip: 87654, email: "go@foogle.com", password: "secure1", password_confirmation: "secure1")

    visit '/merchants'
    click_on "Register"

    expect(current_path).to eq('/register')
    fill_in :name, with: "George Gaw"
    fill_in :address, with: "5 Terrace Pl"
    fill_in :city, with: "Chicago"
    fill_in :state, with: "IL"
    fill_in :zip, with: 00223
    fill_in :email, with: "go@foogle.com"
    fill_in :password, with: "notsosure123"
    fill_in :password_confirmation, with: "notsosure123"
    click_button "Submit"

    expect(current_path).to eq('/register')
    expect(page).to have_content("Email has already been taken")
  end
end
