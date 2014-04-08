require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup" do
    before do
      Capybara.register_driver :rack_test do |app|
        Capybara::RackTest::Driver.new(app, 
                                  :headers => { 'HTTP_EVE_CHARID' => 4587675, 
                                  'HTTP_EVE_TRUSTED' => 'Yes',
                                  'HTTP_EVE_CHARNAME' => 'Jack Sparrow' })
      end
      visit signup_path
    end
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('failed') }
      end

    end

    describe "with valid information" do
      before do
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.character_name) }
        it { should have_selector('div.alert-box.success', text: "Welcome") }
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content('Current Auctions') }
  end

  describe "index page" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should_not have_title('All users') }
    it { should have_content('Current Auctions') }

    describe "as admin user" do

      let(:admin) { FactoryGirl.create(:admin) }

      before do
        sign_in admin
        visit users_path
      end

      it { should have_title('All users') }
      it { should have_content('All users') }

      it { should have_link('delete', href: user_path(User.first)) }

      it "should be able to delete another user" do
        expect do
          click_link('delete', match: :first)
        end.to change(User, :count).by(-1)
      end

      it { should_not have_link('delete', href: user_path(admin)) }
    end
  end
end