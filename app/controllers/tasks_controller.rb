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
    @task.time.change(day: Time.now.day)
    if @task.update(task_params)
      @task.update(time: @task.time.change(day: Time.now.day))
      puts @task.time
      diff = @task.time - Time.now
      seconds = (diff / 1.second).round
      if seconds < 0
        @task.update(time: task.time.change(day: task.time.day + 1))
      end
      @task.save
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
    cmd_params = [{title: "help", usage: "Returns list of availible commands"}, 
                {title: "stop", usage: "Stops the task"},
                {title: "start", usage: "Starts the task"}]
    @task = Task.find_by(short: params[:short])
    if params[:cmd].downcase.start_with?("help") || params[:cmd].downcase.start_with?("h")
      message = "Availible commands are: \n"
      cmd_params.each do |par|
        message += "  #{par["title"]}: #{par["usage"]}\n"
      end
      message += "Any commands not listed above are not currently supported."
      puts message
      @task.logs.push({time: Time.now, message: message})
    elsif params[:cmd].downcase.start_with?("new variable")
      @task.variables.push({ title: params[:cmd][12..-1].sub!(" ", "") })
    elsif params[:cmd].downcase == "stop"
      @task.status = "Stopped"
      @task.logs.push({time: Time.now, message: "Received stop command"}, {time: Time.now, message: "Task stopped."})
    else
      @task.logs.push({time: Time.now, message: "Command '#{params[:cmd]}' not found! Use `help` or `h` to see a list of viable commands."})
    end
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
