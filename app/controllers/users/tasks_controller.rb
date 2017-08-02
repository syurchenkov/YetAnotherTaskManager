class Users::TasksController < ApplicationController
  before_action :logged_in_user
  before_action :owner_user
  before_action :correct_task_user, except: [:show]
  before_action :prepare_task, only: [:show, :edit, :update, :destroy, :rewind, :start, :finish]

  def show 
  end

  def new
    @task = Task.new(user: @user)
  end

  def create 
    @task = @user.tasks.build(task_params)
    if(@task.save)
      flash[:success] = "New task \"#{ @task.name }\" for #{ @user.email } created!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @task.update_attributes(task_params)
      flash[:success] = "Task updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  def destroy 
    @task.destroy
    flash[:success] = "Task deleted"
    redirect_to @user
  end

  def rewind
    @task.rewind!
    redirect_back(fallback_location: user_task_path(@task.user, @task))
  end

  def start
    @task.start!
    redirect_back(fallback_location: user_task_path(@task.user, @task))
  end

  def finish
    @task.finish!
    redirect_back(fallback_location: user_task_path(@task.user, @task))
  end

  private

    def task_params
      params.require(:task).permit(:name, :description)
    end

    def correct_task_user 
      unless correct_task_user?
        flash[:danger] = "You don't have any permissions"
        redirect_to @user
      end
    end

    def owner_user 
      @user ||= User.find(params[:user_id])
    end

    def prepare_task
      @task ||= @user.tasks.find(params[:id])
    end

end
