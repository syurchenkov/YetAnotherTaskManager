class Task < ApplicationRecord
  include AASM
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1000 }

  aasm :column => 'state', :whiny_transitions => false do
    state :new,  :initial => true
    state :started
    state :finished

    event :start do 
      transitions :from => :new, :to => :started
    end

    event :finish do 
      transitions :from => :started, :to => :finished
    end
  end
end
