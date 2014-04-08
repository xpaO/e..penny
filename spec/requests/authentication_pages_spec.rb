require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  # describe "for signed in users" do
  #   let(:user) { FactoryGirl.create(:user) }
  #   before { sign_in user, no_capybara: true }

  #   describe "signed in user trying to access new action" do
  #     before { get new_user_path }
  #     specify { expect(response).to redirect_to(root_url) }
  #   end

  #    describe "signed in user trying to access create action" do
  #      before { post users_path(user) }
  #      specify { expect(response).to redirect_to(root_url) }
  #    end
  # end

  describe "sign in" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert-box.error') }
      describe "after visiting another page" do
        before { click_link "EVE Penny" }
        it { should_not have_selector('div.alert-box.error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.character_name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "Authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the profile page" do
          before { visit user_path(user) }
          it { should have_content('Current Auctions') }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_content('Current Auctions') }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting the profile page" do
        before { visit user_path(wrong_user) }
        it { should have_content('Current Auctions') }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end


      describe "visiting the user index" do
        before { get users_path }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin, no_capybara: true }

      describe "submitting a DELETE request to admin" do
        before { delete user_path(admin) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end