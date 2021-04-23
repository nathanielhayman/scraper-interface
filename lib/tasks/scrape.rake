require 'selenium-webdriver'

def initiate(task)
    puts "[#{Time.now}] Executing task \##{task.id} ~ #{task.short}..."
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'no-sandbox'])
    driver = Selenium::WebDriver.for(:chrome, options: options)
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    logs = driver.manage.logs.get(:browser)

    variables = task.variables
    current_data = []
    errors = []

    elm = nil
    task.task_methods.each do |method|
        sleep(method.delay)
        case method.action_type
        when "GET"
            puts "Begin get method"
            puts method.action
            driver.get(method.action)
        when "find"
            puts "Begin find method"
            if method.action[0] === "." && elm != nil
                begin
                    elm = wait.until { elm.find_element(:xpath, method.action) }
                rescue => exception
                    errors.push({time: Time.now, message: "ERROR: The scraper encountered the following exception during execution: #{exception} [#{task.title} : ##{task.task_methods.find_index(method)}]"})
                end
            else
                begin
                    elm = wait.until { driver.find_element(:xpath, method.action) }
                rescue => exception
                    errors.push({time: Time.now, message: "ERROR: The scraper encountered the following exception during execution: #{exception} [#{task.title} : ##{task.task_methods.find_index(method)}]"})
                end
            end
        when "click"
            elm.click()
            
        when "type"
            elm.send_keys(method.action)
        when "save as"
            puts "Begin save method"
            if variables.map { |j| j['title'] if j['title'] == method.action } != nil
                if elm
                    current_data.push({variable: method.action, result: "#{elm}"})
                else
                    errors.push({time: Time.now, message: "ERROR: Could not find an element to assign variable #{method.action} to. [#{task.title} : ##{task.task_methods.find_index(method)}]"})
                    break
                end
            else
                errors.push({time: Time.now, message: "ERROR: Could not find the variable #{method.action}! [#{task.title} : ##{task.task_methods.find_index(method)}]"})
                break
            end
        end
    end

    puts "*******"
    puts "THE END"
    puts "*******"

    task.update(data: task.data.push({results: current_data}), logs: task.logs + errors)
    task.save

    driver.quit

    ##ReportMailer.with(task: task).report_email.deliver_now
end

def run_threads(tasks) 
    threads = []
    tasks.each do |task|
        threads << Thread.new {
            executing = false
            while true
                sleep(0.5)
                begin
                    task = Task.find_by(short: task.short) 
                rescue => exception
                    Thread.exit
                end
                if not(executing) && task.status === "Running"
                    diff = task.time - Time.now
                    seconds = (diff / 1.second).round
                    puts seconds
                    ##puts "#{task.time}" # - #{Time.now} = #{seconds}"
                    if seconds > 0 && seconds < 2
                        executing = true
                        initiate(task)
                        executing = false
                    elsif seconds < 0
                        puts "<0"
                        # Increment day index of task execution if it has just been run 
                        task.update(time: task.time.change(day: task.time.day + 1))
                        task.save
                    end
                end
            end
        }
    end
    threads.each(&:join)
end

namespace :task_module do

    desc 'Scrapes and interacts with webpages based on user methods'
    task :run, [:task_short] => [:environment] do |t, args|

        puts "[#{Time.now}] Running tasks..."

        cached_tasks = Task.all
        run_threads(cached_tasks)

        while true
            sleep(1000)
            if Task.all != cached_tasks
                run_threads(Task.all - cached_tasks | cached_tasks - Task.all)
            end
        end
    end
end