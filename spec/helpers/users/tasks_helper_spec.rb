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

    describe 'task_state_link' do 
      it 'start when state is new' do 
        expect(helper.task_state_link(new_task)).to include(user_task_start_path(new_task.user, new_task))
      end

      it 'finish when state is started' do 
        expect(helper.task_state_link(started_task)).to include(user_task_finish_path(started_task.user, started_task))
      end

      it 'rewind when state is finished' do 
        expect(helper.task_state_link(finished_task)).to include(user_task_rewind_path(finished_task.user, finished_task))
      end
    end
  end
end
