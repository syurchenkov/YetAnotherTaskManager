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
end