require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  it "can update any users role" do
    admin = create(:admin_user)
    user = create(:random_user)
    user_2 = create(:random_user)
    user_3 = create(:random_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/users"

    expect(user.role).to eq("user")

    within "#user-#{user.id}" do
      expect(page).to have_content('Role')
      select "merchant_admin", :from => "Role"
      click_on "Update"

    end
    user.reload
    expect(user.role).to eq("merchant_admin")
    expect(page).to have_content("The user role has been updated to #{user.role}.")
  end
end
