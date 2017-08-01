require 'rails_helper'

RSpec.describe MainController, type: :controller do

  describe "GET #home" do
    context "when tasks are created" do 
      let!(:valid_user) { create(:valid_user) }
      before(:example) do 
        50.times { create(:task, user: valid_user) }
      end

      it "is render correct template and array of tasks" do
        get :home
        expect(response).to render_template :home
        expect(assigns(:tasks)).to eq( Task.paginate(page: nil) )
      end

      it "is render correct template and array of tasks page 2" do
        page = 2
        get :home, params: { page: page }
        expect(response).to render_template :home
        expect(assigns(:tasks)).to eq( Task.paginate(page: page) )
      end
    end
  end

end
