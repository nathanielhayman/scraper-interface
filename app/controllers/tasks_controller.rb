class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def show
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
  end

  def new
    @tasks = Task.all
    @task = Task.new()
  end

  def create
    @tasks = Task.all
    @task = Task.new(task_params)
    if (@task.logs == nil)
      @task.logs = Array.new
    end
    @task.logs.push({time: Time.now, message: "Creating task..."})
    if @task.save
      flash[:success] = 'Task created.'
      @task.logs.push({time: Time.now, message: "Task created!"})
      @task.save
      redirect_to "/tasks"
    else
      render :new
    end
  end

  def edit
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
  end

  def update
    @tasks = Task.all
    @task = Task.find_by(short: params[:short])
    if @task.update(task_params)
      if @task.time.hour > Time.now.hour && @task.time.day != Time.now.day
        @task.update(time: @task.time.change(day: @task.time.day - 1))
      end
      flash[:success] = 'Task updated.'
      redirect_to "/tasks/show/#{params[:short]}"
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find_by(short: params[:short])
    @task.destroy
    redirect_to "/"
  end

  def retrieve
    @task = Task.find_by(short: params[:short])
    render json: @task.to_json.html_safe
  end

  def cmd
    @task = Task.find_by(short: params[:short])
    @task.logs.push({time: Time.now, message: "Executed command '#{params[:cmd]}'"})
    @task.save
  end

  def toggle
    @task = Task.find_by(short: params[:short])
    if params[:status] == "Running"
      @task.logs.push({time: Time.now, message: "Started #{@task.title}."})
    else
      @task.logs.push({time: Time.now, message: "Stopped #{@task.title}."})
    end
    @task.status = params[:status]
    @task.save
  end

  def star
    @task = Task.find_by(short: params[:short])
    if params[:starred]
      @task.logs.push({time: Time.now, message: "Starred #{@task.title}."})
    else
      @task.logs.push({time: Time.now, message: "Unstarred #{@task.title}."})
    end
    @task.starred = params[:starred]
    @task.save
  end

  def text_editor
    @tasks = Task.all
  end

  def task_params
    params.require(:task).permit(:title, :description, :short, :status, :time, :regularity)
  end
end
