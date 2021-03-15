class TasksController < ApplicationController

  def show
    @tasks = Task.all
    @task = Task.find_by(short: params[:id])
  end

  def new
    @tasks = Task.all
    @task = Task.new()
  end

  def create
    @tasks = Task.all
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = 'Task created.'
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def edit
    @tasks = Task.all
    @task = Task.find_by(short: params[:id])
  end

  def update
    @tasks = Task.all
    if @task.update_attributes(task_params)
      flash[:success] = 'Task updated.'
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :short, :status, :time, :regularity)
  end
end
