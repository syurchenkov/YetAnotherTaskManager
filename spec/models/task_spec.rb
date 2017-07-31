require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    context 'when task with user' do
      let(:user)  { create(:user) }
      let(:task)  { build(:task, user: user) }
      let!(:task2) { create(:task, user: user) }
      let!(:task3) { create(:task, user: user) }

      it 'is valid' do 
        expect(task).to be_valid
      end

      it 'with nil name is invalid' do
        task.name = nil
        expect(task).to_not be_valid
      end

      it 'with blank name is invalid' do 
        task.name = "         "
        expect(task).to_not be_valid
      end

      it 'with name longer 255 is invalid' do 
        task.name = 'a' * 256
        expect(task).to_not be_valid
      end

      it 'with description longer 1000 is invalid' do 
        task.description = 'a' * 1001
        expect(task).to_not be_valid
      end

      it 'with invalid state is invalid' do 
        task.state = "invalid state"
        expect(task).to_not be_valid
      end

      it 'associated tasks are removed' do 
        expect{ user.destroy }.to change { Task.count }.by(-2)
      end
    end

    context 'when task without user' do 
      let(:invalid_task) { build(:task) }

      it 'is invalid' do
        invalid_task.user_id = nil 
        expect(invalid_task).to_not be_valid
      end
    end
  end
end
