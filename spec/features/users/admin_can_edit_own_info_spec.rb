require 'rails_helper'

describe "When user visits dashboard" do
  context "if they are an admin" do
    scenario "they can edit their info" do
      user_admin = Fabricate(:user)

      user_admin.admin!

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_admin)

      visit dashboard_path

      expect(page).to have_content(user_admin.first_name)
      expect(page).to have_content(user_admin.last_name)
      expect(page).to have_content(user_admin.email)
      expect(page).to have_link("Update Account Info")

      click_on("Update Account Info")

      expect(current_path).to eq(edit_user_path(user_admin))

      fill_in "user[first_name]", with: "Jeffery"
      fill_in "user[last_name]", with: "Lebowski"
      fill_in "Username", with: "TheDude"
      fill_in "Email", with: "dude@dude.com"
      fill_in 'user[current_password]', with: user_admin.password
      fill_in 'user[current_password_confirmation]', with: user_admin.password
      fill_in 'user[new_password]', with: "OpinionMan"
      fill_in 'user[new_password_confirmation]', with: "OpinionMan"

      click_on "Update Account"

      expect(current_path).to eq(dashboard_path)

      expect(page).to have_content("Jeffery")
      expect(page).to have_content("Lebowski")
      expect(page).to have_content("TheDude")
      expect(page).to have_content("dude@dude.com")
      expect(page).to have_link("Update Account Info")
      expect(user_admin.password).to eq("OpinionMan")
    end

    scenario "they cannot edit another user's info" do
      user_admin = Fabricate(:user)
      user_admin.admin!
      user_default = Fabricate(:user, username: "Bob", email: "email@jokes.com")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_admin)

      visit dashboard_path

      expect(page).to_not have_content(user_default.username)

      visit(edit_user_path(user_default))

      expect(page).to have_content("Error: 404 page not found")
    end
  end

  context "if they are a default user" do
    scenario "they cannot edit their own info" do
      user = Fabricate(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit dashboard_path

      expect(page).to_not have_content("ADMIN")
      expect(page).to_not have_link("Update Account Info")

      visit(edit_user_path(user))

      expect(page).to have_content("Error: 404 page not found")
    end
  end
end
