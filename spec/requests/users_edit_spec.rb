require 'rails_helper'

RSpec.describe "UsersEdit", type: :request do
  let!(:valid_user) { create(:valid_user) }

  context "when user is logged in" do 
    before(:each) do
      post login_path, params: { 
        session: { 
          email: valid_user.email, 
          password: valid_user.password 
          } 
        } 
    end

    it "is invalid email edit is unseccesfull" do
      get edit_user_path(valid_user)
      expect(response).to render_template('users/edit')
      patch user_path(valid_user), params: { 
        user: { 
          email: "foo@invalid",
          password: "foo",
          password_confirmation: "bar" 
          } 
        }
      expect(response).to render_template('users/edit')
    end

    it "is valid email edit is successfull" do
      get edit_user_path(valid_user)
      expect(response).to render_template('users/edit')
      email = "valid@example.com"
      patch user_path(valid_user), params: { user: { email: email,
                                              password:              valid_user.password,
                                              password_confirmation: valid_user.password } }
      expect(request.flash[:success] ).to_not be_nil
      expect(response).to redirect_to(valid_user)
      valid_user.reload
      expect(valid_user.email).to eq(email)
    end
  end

  context "when user is not logged in" do 

    it "redirect from edit page" do 
      get edit_user_path(valid_user) 
      expect(request.flash[:danger] ).to_not be_nil
      expect(response).to redirect_to(login_url)
    end

    it "redirect after update request" do 
      patch user_path(valid_user), params: { user: { email: valid_user.email } }
      expect(request.flash[:danger] ).to_not be_nil
      expect(response).to redirect_to(login_url)
    end

    it "redirect from index page" do 
      get users_path
      expect(request.flash[:danger] ).to_not be_nil
      expect(response).to redirect_to(login_url)
    end
  end

  context "when user logged in as wrong user" do 
    let!(:wrong_user) { create(:user) }

    before(:each) do
      post login_path, params: { 
        session: { 
          email: wrong_user.email, 
          password: wrong_user.password 
          } 
        } 
    end


    it "redirect from edit page" do 
      get edit_user_path(valid_user) 
      expect(request.flash[:danger] ).to be_nil
      expect(response).to redirect_to(root_url)
    end

    it "redirect after update request" do 
      patch user_path(valid_user), params: { user: { email: valid_user.email } }
      expect(request.flash[:danger] ).to be_nil
      expect(response).to redirect_to(root_url)
    end
  end

end
