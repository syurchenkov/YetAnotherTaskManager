require 'rails_helper'

RSpec.describe "UsersIndex", type: :request do
  before(:example) do 
    100.times { create(:user) }
  end 

  context "when logged in as regular user" do 
    let!(:valid_user){ create(:valid_user) }
    before(:each) do 
      login_request_as(valid_user)
    end

    it "including pagination" do 
      get users_path
      expect(response).to render_template('users/index')
      assert_select('ul.pagination')
      User.paginate(page: 1).each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.email
      end
    end
  end

  context "when logged in as admin" do 
    let!(:admin){ create(:admin) }
    let!(:regular_user){ create(:user) }
  
    it "including pagination, delete links" do 
      login_request_as(admin)
      get users_path
      expect(response).to render_template('users/index')
      assert_select('ul.pagination')
      first_page_of_users = User.paginate(page: 1)
      first_page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.email
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
      end
      expect{ delete user_path(regular_user) }.to change{ User.count }.by(-1)
    end
  end

  context "when logged in as non admin" do 
    let!(:non_admin) { create(:user) } 

    it "does not have delete links" do
      login_request_as(non_admin)
      get users_path
      assert_select 'a', text: 'delete', count: 0
    end
  end
end