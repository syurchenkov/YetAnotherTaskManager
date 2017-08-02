class Task < ApplicationRecord
  include AASM
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 1000 }
  mount_uploader :file, FileUploader
  validate  :file_size

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

    event :rewind do 
      transitions :from => :finished, :to => :new
    end
  end

  def file_is_image? 
    %w(.jpg .jpeg .gif .png).include? File.extname(file.url)
  end

  private

    # Validates the size of an uploaded file.
    def file_size
      if file.size > 20.megabytes
        errors.add(:file, "should be less than 20MB")
      end
    end
end
