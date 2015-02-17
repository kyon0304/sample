require 'spec_helper'

describe "Static pages" do

  let (:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector( 'h1', text: heading ) }
    it { should have_selector( 'title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }

    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector( 'title', text: full_title('Home') ) }

    describe "for signed in user" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dior sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      #it "should have correct microposts count" do
      #  page.should have_content(user.microposts.count)
      #  page.should have_selector("span", text: "microposts")
      #end

#      describe "pagination" do
#        before(:all) do
#          50.times do |n|
#            content = Faker::Lorem.sentence(5)
#            user.microposts.create!(content: content)
#          end
#          visit root_path
#        end
#
#        it { should have_selector("div.pagination") }
#        it "should list each micropost" do
#          user.microposts.paginate(page: 1).each do |m|
#            page.should have_selector("li", id: m.id)
#          end
#        end
#        after(:all) { user.microposts.delete_all }
#      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }
  end

  describe "About page" do
    before { visit about_path }

    let(:heading) { 'About' }
    let(:page_title) { 'About' }
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }
  end

  describe "static pages" do
    it "should have the correct links on the layout" do
      visit root_path
      click_link "About"
      page.should have_selector "title", text: full_title("About")
      click_link "Help"
      page.should have_selector "title", text: full_title("Help")
      click_link "Contact"
      page.should have_selector "title", text: full_title("Contact")
      click_link "sample app"
      page.should have_selector "h1", text: "Sample App"
      click_link "Home"
      click_link "Sign up now!"
      page.should have_selector "title", text: full_title("Sign up")
    end
  end
end


#describe "StaticPages" do
#  describe "GET /static_pages" do
#    it "works! (now write some real specs)" do
#      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#      get static_pages_index_path
#      response.status.should be(200)
#    end
#  end
#end
