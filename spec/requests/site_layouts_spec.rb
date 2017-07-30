require 'rails_helper'

RSpec.describe "SiteLayouts", type: :request do
  describe "GET root_path" do
    it "render links" do
      get root_path
      expect(response).to be_success
      expect(response).to render_template('main/home')
      assert_select "a[href=?]", root_path, count: 2
    end
  end
end
