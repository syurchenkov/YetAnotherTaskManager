class MainController < ApplicationController
  def home
    @tasks = Task.paginate(page: params[:page])
  end
end
