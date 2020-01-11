require 'rails_helper'
RSpec.describe "admin all user show page" do
  it "sees all user in the system" do
    user = create(:admin_user)
    ray = create(:regular_user, name: "Ray Win")
    jomah = create(:regular_user, email: "rad@gmail.com")
    wren = create(:regular_user, email: "rad1@gmail.com")
    becky = create(:regular_user, email: "rad2@gmail.com")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/admin/users"
    
    expect(page).to have_content(ray.name)
    expect(page).to have_content(ray.role)
    expect(page).to have_content(ray.created_at)
    expect(page).to have_content(jomah.name)
    expect(page).to have_content(jomah.role)
    expect(page).to have_content(jomah.created_at)
    expect(page).to have_content(wren.name)
    expect(page).to have_content(wren.role)
    expect(page).to have_content(wren.created_at)
    expect(page).to have_content(becky.name)
    expect(page).to have_content(becky.role)
    expect(page).to have_content(becky.created_at)
    expect(User.all.count).to eq(5)

    expect(page).to have_link(ray.name)

    click_on "#{ray.name}"

    expect(current_path).to eq("/admin/users/#{ray.id}")
  end

  it "can edit all user in the system" do 
    user = create(:admin_user)
    ray = create(:regular_user, name: "Ray Win")
    jomah = create(:regular_user, email: "rad@gmail.com")
    wren = create(:regular_user, email: "rad1@gmail.com")
    becky = create(:regular_user, email: "rad2@gmail.com")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "admin/users/#{ray.id}"

    expect(page).to have_link("Edit #{ray.name} information.")
    expect(page).to have_link("Edit #{ray.name} password.")
    
    click_on "Edit #{ray.name} information."

    expect(current_path).to eq("/admin/users/#{ray.id}/edit")

    fill_in :name, with: "LucII"
    fill_in :address, with: "666 Meyers Lane"

    click_button "Submit"
    expect(current_path).to eq("/admin/users/#{ray.id}")

    ray.reload

    click_on "Edit #{ray.name} password."

    expect(current_path).to eq("/admin/users/#{ray.id}/edit_password")

    fill_in :password, with: "trash"
    fill_in :password_confirmation, with: "trash"
    click_button "Submit"
    ray.reload
    expect(current_path).to eq("/admin/users/#{ray.id}")
    expect(page).to have_content("Password has been updated.")
  end 

  it "can not change password if doesnt match" do
    user = create(:admin_user)
    ray = create(:regular_user, name: "Ray Win")
    jomah = create(:regular_user, email: "rad@gmail.com")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "admin/users/#{ray.id}"

    click_on "Edit #{ray.name} password."

    expect(current_path).to eq("/admin/users/#{ray.id}/edit_password")

    fill_in :password, with: "trash"
    fill_in :password_confirmation, with: "nottrash"
    click_button "Submit"
    ray.reload
    expect(current_path).to eq("/admin/users/#{ray.id}/edit_password")
    expect(page).to have_content("Passwords entered do not match.")
  end

  it "can not change user information if blank" do
    user = create(:admin_user)
    ray = create(:regular_user, name: "Ray Win")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "admin/users/#{ray.id}"

    expect(page).to have_link("Edit #{ray.name} information.")
    expect(page).to have_link("Edit #{ray.name} password.")
    
    click_on "Edit #{ray.name} information."

    expect(current_path).to eq("/admin/users/#{ray.id}/edit")

    fill_in :name, with: "LucII"
    fill_in :address, with: ""

    click_button "Submit"
    expect(current_path).to eq("/admin/users/#{ray.id}")
    expect(page).to have_content("Address can't be blank")
  end
end
