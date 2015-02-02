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
      before do
        fill_in "Name", with: "kyon"
        fill_in "Email", with: "kyon@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email("kyon@example.com") }

        it { should have_selector( "h1", text: user.name) }
        it { should have_selector( "div.alert.alert-success", text: "Welcome") }
      end
    end

    describe "with invalid information, error messages" do 
      before { click_button submit }
      it "should pop error messages" do
        
      end
    end
  end
end

