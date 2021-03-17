class MethodsController < ApplicationController
  def index
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
  end

  def new
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
    @method = @task.task_methods.new()
  end

  def edit
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
    @method = @task.task_methods.find_by(id: params[:id])
  end

  def create
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
    @method = @task.task_methods.new(task_method_params)
    if @method.save
      redirect_to "/tasks/show/#{@task.short}"
    else
      redirect_to "/tasks"
    end
  end

  def update
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
    @method = @task.task_methods.find_by(id: params[:id])
    if @method.update(task_method_params)
      flash[:success] = 'Method updated.'
      redirect_to "/tasks"
    else
      render :edit
    end
  end

  def task_method_params
    params.require(:task_method).permit(:action_type, :action, :delay)
  end
end
