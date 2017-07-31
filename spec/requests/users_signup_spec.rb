require 'rails_helper'

RSpec.describe "UsersSignup", type: :request do
  describe "with invalid infomation" do
    it "does not change users count" do
      get signup_path
      invalid_information = { 
        user: { 
          email: "user@invalid",
          password:              "foo",
          password_confirmation: "bar" 
        } 
      }
      expect{ post users_path, params: invalid_information }.to_not change { User.count }
      render_template('users/new')
    end
  end

  describe "with valid infomation" do
    it "change users count by 1" do
      get signup_path
      valid_information = {
        user: {
          email: "user@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
      expect{ post users_path, params: valid_information }.to change { User.count }.by(1)
      follow_redirect!
      render_template('users/show')
      expect(is_logged_in?).to be true
    end
  end
end