require 'rails_helper'

RSpec.describe "log out user" do
  it "can log out the user" do
    visit '/merchants'
    click_on "Register"

    expect(current_path).to eq('/register')
    fill_in :name, with: "Charley Mae"
    fill_in :address, with: "4 Bunker Ln"
    fill_in :city, with: "Lebanon"
    fill_in :state, with: "KS"
    fill_in :zip, with: 55555
    fill_in :email, with: "mol@google.com"
    fill_in :password, with: "notsecure123"
    fill_in :password_confirmation, with: "notsecure123"
    click_button "Submit"

    new_user = User.last
    expect("#{new_user.name}").to eq("Charley Mae")
    expect(current_path).to eq('/profile')
    click_link("Log Out")
    expect(current_path).to eq('/')
    expect(page).to have_content("You are now logged out.")
    expect(page).to have_link("Log In")
  end
  it "destroys cart at log out" do
    visit '/merchants'
    click_on "Register"

    expect(current_path).to eq('/register')
    fill_in :name, with: "Charley Mae"
    fill_in :address, with: "4 Bunker Ln"
    fill_in :city, with: "Lebanon"
    fill_in :state, with: "KS"
    fill_in :zip, with: 55555
    fill_in :email, with: "mol@google.com"
    fill_in :password, with: "notsecure123"
    fill_in :password_confirmation, with: "notsecure123"
    click_button "Submit"

    new_user = User.last
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    expect(page).to have_link("Cart: 2")

    click_link("Log Out")
    expect(current_path).to eq('/')
    expect(page).to have_content("You are now logged out.")
    expect(page).to have_link("Log In")
    expect(page).to have_content("Cart: 0")

    click_on "Log In"
    fill_in :email, with: "mol@google.com"
    fill_in :password, with: "notsecure123"
    click_button "Log In"

    expect(page).to have_content("Cart: 0")
    
  end
end
