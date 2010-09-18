require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          click_button
          response.should render_template('new')
          response.should have_tag("div#errorExplanation")
        end.should_not change(User, :count)
      end
    end
  end

  describe "sign in/out" do

    describe "failure" do
      
      it "should not sign a user in" do
        visit signin_path
        fill_in :email,     :with => ""
        fill_in :password,  :with => ""
        click_button
        response.should render_template('sessions/new')
        response.should have_tag("div.flash.error", /invalid/i)
      end
    end

    describe "success" do 
    
      it "should sign a user in and out" do
        user = Factory(:user)
        visit signin_path
        fill_in :email,     :with => user.email
        fill_in :password,  :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_no be_signed_in
      end
    end
  end

  describe "remember me" do
    
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have a remember token" do
      @user.should respond_to(:remember_token)
    end

    it "should have a remember_me! method" do
      @user.should respond_to(:remember_me!)
    end

    it "should set the remember token" do
      @user.remember_me!
      @user.remember_token.should_not be_nil
    end
  end
end