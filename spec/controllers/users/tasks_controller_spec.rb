require 'rails_helper'

RSpec.describe Users::TasksController, type: :controller do
  describe 'login as regular user' do
    let!(:valid_user) { create(:user) }
    let!(:task) { create(:task, user: valid_user, name: 'OldName') }
    before(:each) { request.session[:user_id] = valid_user.id }

    describe 'successfull requests' do 
      let!(:valid_user) { create(:user) }
      let!(:task) { create(:task, user: valid_user, name: 'OldName') }
      before(:each) { request.session[:user_id] = valid_user.id }

      it 'GET :new' do 
        get :new, params: {user_id: valid_user.id}
        expect(response).to render_template('users/tasks/new')
      end

      it 'GET :show' do 
        get :show, params: {user_id: valid_user.id, id: task.id}
        expect(response).to render_template('users/tasks/show')
      end

      it 'GET :edit' do 
        get :edit, params: {user_id: valid_user.id, id: task.id}
        expect(response).to render_template('users/tasks/edit')
      end

      it 'POST :create' do 
        expect{
          post :create, params: {
            user_id: valid_user.id,
            task: {
              name: 'name',
              description: 'description'
            }
          }
        }.to change{ valid_user.tasks.count }.by(1)
      end

      it 'PATCH :update' do 
        new_name = 'NewName'
        patch :update, params: {
          user_id: valid_user.id,
          id: task.id,
          task: {
            name: new_name,
          }
        }
        expect(task.reload.name).to eq(new_name)
      end

      it 'PATCH :start' do 
        patch 'start', params: {user_id: valid_user.id, id: task.id}
        expect(task.reload.state).to eq('started')
        expect(response).to redirect_to(user_task_path(valid_user, task))
      end

      it 'PATCH :finish' do 
        task.start!
        patch :finish, params: {user_id: valid_user.id, id: task.id}
        expect(task.reload.state).to eq('finished')
        expect(response).to redirect_to(user_task_path(valid_user, task))
      end

      it 'PATCH :rewind' do 
        task.start!
        task.finish!
        patch :rewind, params: {user_id: valid_user.id, id: task.id}
        expect(task.reload.state).to eq('new')
        expect(response).to redirect_to(user_task_path(valid_user, task))
      end

      it 'DELETE :destroy' do
        expect{
          delete :destroy, params: {
            user_id: valid_user.id,
            id: task.id
          }
        }.to change{
          valid_user.tasks.count
        }
      end
    end

    describe 'unsuccessfull requests' do
      it 'POST :create' do 
        expect{
          post :create, params: {
            user_id: valid_user.id,
            task: {
              name: '',
              description: 'description'
            }
          }
        }.to_not change{ valid_user.tasks.count }
        expect(response).to render_template('users/tasks/new')
      end

      it 'PATCH :update' do 
        old_name = task.name
        patch :update, params: {
          user_id: valid_user.id,
          id: task.id,
          task: {
            name: ' ',
          }
        }
        expect(task.reload.name).to eq(old_name)
        expect(response).to render_template('users/tasks/edit')
      end
    end
  end
end
