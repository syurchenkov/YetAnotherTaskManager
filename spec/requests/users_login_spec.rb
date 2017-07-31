require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  describe "login with invalid information" do
    it "render flash error" do
      get login_path
      expect(response).to be_success
      expect(response).to render_template('sessions/new')
      post login_path, params: { session: { email: "", password: "" } }
      expect(response).to render_template('sessions/new')
      expect(request.flash[:danger] ).to_not be_nil
      get root_path 
      expect(request.flash[:danger] ).to be_nil
    end
  end

  describe "login with valid information and log out" do
    let(:valid_user) { create(:valid_user) }

    it "enter to private user page" do 
      get login_path
      expect(response).to be_success
      expect(response).to render_template('sessions/new')
      post login_path, params: { session: { email: valid_user.email, password: 'password' } }
      expect(response).to redirect_to(valid_user)
      follow_redirect!
      expect(response).to render_template 'users/show'
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", user_path(valid_user)
      # log out
      delete logout_path
      expect(is_logged_in?).to be false
      expect(response).to redirect_to(root_path)
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,      count: 0
      assert_select "a[href=?]", user_path(valid_user), count: 0
    end
  end
end