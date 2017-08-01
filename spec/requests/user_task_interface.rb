require 'rails_helper'

RSpec.describe "UserTaskInterface", type: :request do
  context 'when user interacts with his task' do 
    let!(:user) { create(:user) }
    let!(:task) { create(:task, user: user, name: 'taskname') }
    before(:each) do 
      login_request_as(user)
    end

    it "shows user page with tasks" do 
      get user_path(user)
      expect(response.body).to include(user.email)
      expect(response).to render_template('users/show')
    end

    it 'shows user task page' do 
      get user_task_path(user, task)
      expect(response.body).to include(task.name)
      expect(response).to render_template('users/tasks/show')
    end

    it 'shows task edit page' do 
      get edit_user_task_path(user, task)
      expect(response.body).to include(task.name)
      expect(response).to render_template('users/tasks/edit')
    end

    it 'shows new task page' do 
      get new_user_task_path(user, task)
      expect(response).to render_template('users/tasks/new')
    end

    it 'allows update task' do 
      new_name = 'New Name For Task'
      patch user_task_path(user, task), params:{
        task: {
          name: new_name
        }
      }
      expect(task.reload.name).to eq(new_name)
    end

    it 'allows create task' do 
      expect{
        post user_tasks_path(user), params: { 
          task: { 
            name: 'name',
            description: 'desc'
          } 
        }
      }.to change{
        user.tasks.count
      }.by(1)
    end

    it 'allows delete task' do 
      expect{ 
        delete user_task_path(user, task)
      }.to change{ 
        user.tasks.count 
      }.by(-1)
    end
  end

  context "when not logged in user interacts with tasks" do
    let!(:user) { create(:user) }
    let!(:task) { create(:task, user: user) }

    describe 'redirects to login page from' do 
      after(:each) do 
        expect(response).to redirect_to login_url
      end

      it "user page" do 
        get user_path(user)
      end

      it "task page" do 
        get user_task_path(user, task)
      end

      it 'task edit page' do 
        get edit_user_task_path(user, task)
      end

      it 'new task page' do 
        get new_user_task_path(user, task)
      end
    end

    it 'denies update task' do
      new_name = 'New Name For Task' 
      patch user_task_path(user, task), params:{
        task: {
          name: new_name
        }
      }
      expect(task.reload.name).to_not eq(new_name)
    end

    describe 'denies' do 
      let!(:tasks_number){ user.tasks.count }
      after(:each) do
        expect(user.tasks.count).to eq(tasks_number)
      end

      it 'create task' do 
        post user_tasks_path(user), params: { 
          task: { 
            name: 'name',
            description: 'desc'
          } 
        }
      end

      it 'delete task' do 
        delete user_task_path(user, task)
      end
    end    
  end
end