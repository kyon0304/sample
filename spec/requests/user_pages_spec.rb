require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "Sign up pages" do
    before { visit signup_path }
    it { should have_selector( 'h1', text: 'Sign up' ) }
    it { should have_selector( 'title', text: full_title( 'Sign up' ) ) }
  end

  describe "Profile pages" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_selector( 'h1', text: user.name ) }
    it { should have_selector( 'title', text: user.name ) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change( User, :count )
      end

      describe "after submition" do
        before { click_button submit }
        
        it { should have_selector( "title", text: "Sign up") }
        it { should have_selector( "form", text: "errors" ) }
      end
    end

    describe "with valid information" do
      before { valid_signup }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email("kyon@world.com") }

        it { should have_selector( "h1", text: user.name) }
        it { should have_success_messages("Welcome") }
        it { should have_link("Sign out") }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end 

    describe "page" do
      it { should have_selector("h1", text:"Update your profile") }
      it { should have_selector("title", text:"Edit user") }
      it { should have_link("change", href:"http://www.gravatar.com/email") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content("error") }
    end

    describe "with valid information" do
      let(:new_name) { "New name" }
      let(:new_email) { "new@example.com" }
      before { valid_edit(new_name, new_email, user) }

      it { should have_selector("title", text: new_name) }
      it { should have_success_messages }
      it { should have_link("Sign out", href: signout_path) }

      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector("title", text: "All users") }
    it { should have_selector("h1", text: "All users") }
    it "should list each user" do
      User.all.each do |user|
        page.should have_selector("li", text: user.name)
      end
    end

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }
      
      it { should have_selector("div.pagination") }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector("li", text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link("delete") }

      describe "as an admin" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link("delete", href: user_path(User.first)) }
        it "should be abe to delete another user" do
          expect { click_link("delete").to change(User, :count).by(-1) }
        end
        it { should_not have_link("delete", href: user_path(admin)) }
      end
    end
  end

  describe "Account dropdown menu" do
    it { should_not have_link("Account") }
  end

end
