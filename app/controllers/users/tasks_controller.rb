class Users::TasksController < ApplicationController
  before_action :owner_user

  def new
    @task = Task.new(user: @owner_user)
  end

  def create 
    @task = @owner_user.tasks.build(task_params)
    if(@task.save)
      flash[:success] = "New task \"#{ @task.name }\" for user #{ @owner_user.email } created!"
      redirect_to user_task_url(@owner_user, @task)
    else
      render 'new'
    end
  end

  def show 
    @task = @owner_user.tasks.find(params[:id])
  end

  def index 
    @tasks = @owner_user.tasks
  end

  private

    def task_params
      params.require(:task).permit(:name, :description)
    end

    # before 
    def owner_user 
      @owner_user ||= User.find(params[:user_id]) 
    end
end
