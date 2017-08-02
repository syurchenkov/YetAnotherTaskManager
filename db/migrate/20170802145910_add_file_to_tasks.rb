class AddFileToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :file, :string
  end
end
