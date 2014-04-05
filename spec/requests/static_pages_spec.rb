require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_title(full_title(page_title)) }
    it { should have_selector('h1', text: heading) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:page_title) { "" }
    let(:heading) { "Current Auctions" }
    
    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
  end

  describe "FAQ page" do
    before { visit faq_path }
    let(:page_title) { "FAQ" }
    let(:heading) { "FAQ" }
    
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:page_title) { "About us" }
    let(:heading) { "About" }
    
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:page_title) { "Contact" }
    let(:heading) { "Contact" }
    
    it_should_behave_like "all static pages"
  end

  describe "Trust page" do
    before { visit trust_path }
    let(:page_title) { "Trust EVE Penny" }
    let(:heading) { "Trust EVE Penny" }
    
    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About us'))
    click_link "FAQ"
    expect(page).to have_title(full_title('FAQ'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "EVE Penny"
    expect(page).to have_title(full_title(''))
    click_link "Sign up"
    expect(page).to have_title(full_title('Sign up'))
  end
end