class MethodsController < ApplicationController
  def index
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
  end

  def new
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
    @method = @task.task_methods.create()
  end

  def edit

  end

  def create
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
    @method = @task.task_methods.create(params[:task_method].permit(:action_type, :action, :delay))
    if @method.save
      redirect_to "/tasks/show/#{@task.short}"
    else
      redirect_to "/tasks"
    end
  end

  def update
  end
end
