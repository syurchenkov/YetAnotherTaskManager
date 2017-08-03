namespace :utils do
  desc "Populate database with fake users and tasks"
  task populate_database: :environment do
    100.times do 
      user = FactoryGirl.create(:user)
      5.times do 
        FactoryGirl.create(:task_with_random_state, user: user)
      end
    end
  end
end
