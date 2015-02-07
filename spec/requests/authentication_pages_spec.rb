require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }
    
    it { should have_selector("title", text: "Sign in") }
    it { should have_selector("h1", text: "Sign in") }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector("title", text: "Sign in") }
      it { should have_error_messages("Invalid") }

      describe "after visiting another page" do
        before { click_link "Home"}

        it { should_not have_error_messages() }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }
      
      it { should have_selector("title", text: user.name) }
      it { should have_link("Users", href: users_path) }
      it { should have_link("Profile", href: user_path(user)) }
      it { should have_link("Settings", href: edit_user_path(user)) }
      it { should have_link("Sign out", href: signout_path) }
      it { should_not have_link("Sign in", href: signin_path) }

      describe "after click Sign out" do
        before { click_link "Sign out" }

        it { should have_link("Sign in") }
        it { should_not have_link("Settings") }
      end
    end
  end

  describe "authorization" do
    
    describe "for not-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do 
          visit edit_user_path(user)
          valid_signin(user)
        end

        describe "after signing in" do
          it { should have_selector("title", text: full_title("Edit user")) }
        end
      end

      describe "in the Users controller" do
      
        describe "visit the editing page" do
          before { visit edit_user_path(user) }
          it { should have_selector("title", text: "Sign in") }
        end

        describe "submitting the update" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector("title", text: "Sign in") }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "Visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector("title", text: full_title('Edit user')) }
      end

      describe "Submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to root_path }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin} 

      describe "Submitting a delete requset to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
