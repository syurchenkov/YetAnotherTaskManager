require 'rails_helper'

RSpec.describe Users::TasksController, type: :controller do
  describe 'User' do 
    before(:each) do 
      @regular_user = create(:user, :with_task)
      @regular_user_task = @regular_user.tasks.first
      @user = create(:user, :with_task)
      @task = @user.tasks.first
      @admin = create(:admin)
    end

    context 'when not logged in' do 

      it 'redirect from task page' do 
        get :show, params: { user_id: @user.id, id: @task.id }
        expect(response).to redirect_to login_url
      end

      it 'can not create task to another user' do 
        expect{
          post :create, params: { user_id: @user.id, task: {name: @task.name, description: @task.description} }
        }.to_not change{ @user.tasks.count }
      end
    end

    context 'when logged in as regular_user' do 
      before(:each) { log_in_as(@regular_user) }

      it 'can browse another user task' do 
        get :show, params: {user_id: @user.id, id: @task.id } 
        expect(response).to render_template 'users/tasks/show'
      end

      it 'can not create task to another user' do 
        expect{
          post :create, params: { user_id: @user.id, task: {name: @task.name, description: @task.description} }
        }.to_not change{ @user.tasks.count }
      end

      it 'can browse own new task page' do 
        get :new, params: {user_id: @regular_user}
        expect(assigns(:task)).to be_a_new(Task)
        expect(assigns(:task).user).to eq(@regular_user) 
      end

      it 'can create own task' do 
        expect{
          post :create, params: { user_id: @regular_user.id, task: {name: @task.name, description: @task.description} }
        }.to change{ @regular_user.tasks.count }.by(1)
      end

      it 'can not create own task with invalid parametres' do 
        expect{
          post :create, params: { user_id: @regular_user.id, task: {name: '', description: ''} }
        }.to_not change{ @regular_user.tasks.count }
        expect(response).to render_template 'users/tasks/new'
      end

      it 'can update own task' do 
        new_name = 'NEWNAME'
        patch :update, params: { user_id: @regular_user.id, id: @regular_user_task.id, task: { name: new_name}}
        expect(@regular_user_task.reload.name).to eq(new_name)
      end

      it 'can not update own task with invalid parametres' do 
        new_name = ''
        patch :update, params: { user_id: @regular_user.id, id: @regular_user_task.id, task: { name: new_name}}
        expect(@regular_user_task.reload.name).to_not eq(new_name)
      end

      it 'can start own task' do 
        patch :start, params: {user_id: @regular_user.id, id: @regular_user_task.id}
        expect(@regular_user_task.reload.state).to eq('started')
      end

      it 'can finish own task' do
        @regular_user_task.start!
        patch :finish, params: {user_id: @regular_user.id, id: @regular_user_task.id}
        expect(@regular_user_task.reload.state).to eq('finished')
      end

      it 'can rewind own task' do 
        @regular_user_task.start!
        @regular_user_task.finish!
        patch :rewind, params: {user_id: @regular_user.id, id: @regular_user_task.id}
        expect(@regular_user_task.reload.state).to eq('new')
      end

      it 'can destroy own task' do 
        expect{
          delete :destroy, params: {user_id: @regular_user.id, id: @regular_user_task.id}
        }.to change {@regular_user.tasks.count}.by(-1)
      end
    end

    context 'when logged in as admin' do 
      before(:each) { log_in_as(@admin) }

      it 'can browse another user task' do 
        get :show, params: {user_id: @user.id, id: @task.id } 
        expect(response).to render_template 'users/tasks/show'
      end

      it 'can create task to another user' do 
        expect{
          post :create, params: { user_id: @user.id, task: {name: @task.name, description: @task.description} }
        }.to change{ @user.tasks.count }.by(1)
      end
    end
  end
end