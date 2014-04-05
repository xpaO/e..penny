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

      # describe "after saving the user" do
      #   before { click_button submit }
      #   let(:user) { User.find_by(ema]il: 'user@example.com') }

      #   it { should have_link('Sign out') }
      #   it { should have_title(user.name) }
      #   it { should have_success_message('Welcome') }
      # end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end