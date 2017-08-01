class Users::TasksController < ApplicationController
  before_action :owner_user
  before_action :owner_user_task, only: [:show, :edit, :update, :destroy]

  def index 
    @tasks = @owner_user.tasks
  end

  def show 
  end

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

  def edit
  end

  def update
    if @task.update_attributes(task_params)
      flash[:success] = "Task updated"
      redirect_to @owner_user
    else
      render 'edit'
    end
  end


  def destroy 
    @task.destroy
    flash[:success] = "Task deleted"
    redirect_to @owner_user
  end

  private

    def task_params
      params.require(:task).permit(:name, :description)
    end

    # before 
    def owner_user 
      @owner_user ||= User.find(params[:user_id]) 
    end

    def owner_user_task
      @task ||=  @owner_user.tasks.find(params[:id])
    end
end
