require 'rails_helper'


RSpec.describe Users::TasksHelper, type: :helper do
  describe "Task helpers" do 
    let!(:user) { create(:user)}
    let!(:new_task) { create(:task, user: user) }
    let!(:started_task) { create(:task, user: user) }
    let!(:finished_task) { create(:task, user: user) }
    before(:example) do 
      started_task.start!
      finished_task.start!
      finished_task.finish!
    end

    describe 'task_state_to_css_class' do

      it 'danger when state is new' do 
        expect(helper.task_state_to_css_class(new_task.state)).to eq('danger')
      end

      it 'warning when state is started' do 
        expect(helper.task_state_to_css_class(started_task.state)).to eq('warning')
      end

      it 'success when state is finished' do 
        expect(helper.task_state_to_css_class(finished_task.state)).to eq('success')
      end

    end

    describe 'task_state_path' do 
      it 'return start path for new task' do 
        expect(helper.task_state_path(new_task)).to eq(start_user_task_path(new_task.user, new_task))
      end

      it 'return finish path for started task' do 
        expect(helper.task_state_path(started_task)).to eq(finish_user_task_path(started_task.user, started_task))
      end

      it 'return rewind path for finished task' do 
        expect(helper.task_state_path(finished_task)).to eq(rewind_user_task_path(finished_task.user, finished_task))
      end
    end

    describe 'task_state_action' do 
      it 'start for new task' do 
        expect(helper.task_state_action(new_task)).to eq('start')
      end

      it 'finish for started task' do 
        expect(helper.task_state_action(started_task)).to eq('finish')
      end

      it 'rewind for finished task' do 
        expect(helper.task_state_action(finished_task)).to eq('rewind')
      end

    end
  end
end
