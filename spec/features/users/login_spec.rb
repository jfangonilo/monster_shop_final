require 'rails_helper'

RSpec.describe "As a visitor when I visit login path", type: :feature do
  describe "I see a field to enter my email address and password" do
    it "when I submit valid information I am redirected back to my profile page" do

      regular_user = User.create!(name: "Becky",
                                 address: "123 Main",
                                 city: "Broomfield",
                                 state: "CO",
                                 zip: 80020,
                                 email: "go@foogle.com",
                                 password: "notsecure123",
                                 role: 0)

      visit '/merchants'
      click_on 'Log In'

      expect(current_path).to eq("/login")

      fill_in :email, with: "go@foogle.com"
      fill_in :password, with: "notsecure123"
      click_button "Log In"

      expect(current_path).to eq("/profile")

      expect(page).to have_content("Welcome go@foogle.com")
    end

    it "won't login if email does not match" do

      new_user = create(:regular_user, email: "yo@gmail.com", password: "123password", password_confirmation: "123password")

      visit '/merchants'
      click_on 'Log In'

      expect(current_path).to eq("/login")

      fill_in :email, with: "erwq@gmail.com"
      fill_in :password, with: "notsecure123"

      click_button "Log In"

      expect(current_path).to eq("/login")
      expect(page).to have_content("Sorry Invalid Password or Email.")
    end
    it "won't login if password isn't entered" do

      new_user = create(:regular_user, email: "yo@gmail.com", password: "123password", password_confirmation: "123password")

      visit '/merchants'
      click_on 'Log In'

      expect(current_path).to eq("/login")
      fill_in :email, with: "yo@gmail.com"
      fill_in :password, with: ""
      click_button "Log In"

      expect(current_path).to eq("/login")
      expect(page).to have_content("Sorry Invalid Password or Email.")
    end

    it "when I am a merchant user I am redirected to my merchant dashboard" do
      diana = create(:merchant_employee)
      becky = create(:merchant_admin)

      visit '/merchants'
      click_on 'Log In'

      expect(current_path).to eq("/login")

      fill_in :email, with: diana.email
      fill_in :password, with: diana.password

      click_button "Log In"

      expect(current_path).to eq('/merchant')
      expect(page).to have_content("Welcome Merchant #{diana.email}")
      click_on "Log Out"

      visit '/merchants'
      click_on 'Log In'

      expect(current_path).to eq("/login")

      fill_in :email, with: becky.email
      fill_in :password, with: becky.password

      click_button "Log In"

      expect(current_path).to eq('/merchant')
      expect(page).to have_content("Welcome Merchant #{becky.email}")


    end

    it "when I am an admin user I am redirected to my admin dashboard page" do
      barry = create(:admin_user)

      visit '/merchants'
      click_on 'Log In'

      expect(current_path).to eq("/login")

      fill_in :email, with: barry.email
      fill_in :password, with: barry.password

      click_button "Log In"

      expect(current_path).to eq('/admin')
      expect(page).to have_content("Welcome Admin #{barry.email}!")
    end

    describe "will redirect all users if they are already logged in" do
      it "as regular user, I am redirected to my profile page" do
        becky = create(:regular_user)

        visit '/merchants'
        click_on 'Log In'

        expect(current_path).to eq("/login")

        fill_in :email, with: becky.email
        fill_in :password, with: becky.password
        click_button "Log In"

        expect(current_path).to eq('/profile')
        expect(page).to have_content("Welcome #{becky.email}")

        visit "/login"
        expect(current_path).to eq('/profile')
        expect(page).to have_content("You are already logged in.")
      end

      it "as a merchant user, I am redirected to my merchant dashboard page " do
        sarah = create(:merchant_admin)
        paul = create(:merchant_employee)

        visit '/merchants'
        click_on 'Log In'

        fill_in :email, with: sarah.email
        fill_in :password, with: sarah.password
        click_button "Log In"

        expect(current_path).to eq('/merchant')
        expect(page).to have_content("Welcome Merchant #{sarah.email}")

        visit "/login"
        expect(current_path).to eq('/merchant')
        expect(page).to have_content("You are already logged in.")
        click_on "Log Out"

        visit '/merchants'
        click_on 'Log In'

        fill_in :email, with: paul.email
        fill_in :password, with: paul.password
        click_button "Log In"

        expect(current_path).to eq('/merchant')
        expect(page).to have_content("Welcome Merchant #{paul.email}")

        visit "/login"
        expect(current_path).to eq('/merchant')
        expect(page).to have_content("You are already logged in.")

      end

      it "as am an admin user, I am redirected to my admin dashboard page " do
          barry = create(:admin_user)

          visit '/merchants'
          click_on 'Log In'

          expect(current_path).to eq("/login")

          fill_in :email, with: barry.email
          fill_in :password, with: barry.password
          click_button "Log In"

          expect(current_path).to eq('/admin')
          expect(page).to have_content("Welcome Admin #{barry.email}")

          visit "/login"
          expect(current_path).to eq('/admin')
          expect(page).to have_content("You are already logged in.")
      end
    end
  end
end
