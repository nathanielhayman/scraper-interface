require 'selenium-webdriver'

def initiate(task)
    puts "[#{Time.now}] Executing task \##{task.id} ~ #{task.short}..."
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'no-sandbox'])
    driver = Selenium::WebDriver.for(:chrome, options: options)
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    logs = driver.manage.logs.get(:browser)

    variables = task.variables

    elm = nil
    task.task_methods.each do |method|
        sleep(method.delay)
        case method.action_type
        when "GET"
            puts method.action
            driver.get(method.action)
        when "find"
            if method.action[0] === "." && elm != nil
                elm = wait.until { elm.find_element(:xpath, method.action) }
            else
                elm = wait.until { driver.find_element(:xpath, method.action) }
            end
        when "click"
            elm.click()
        when "type"
            elm.send_keys(method.action)
        end
    end

    driver.quit

    ReportMailer.with(task: task).report_email.deliver_now
end

def run_threads(tasks) 
    threads = []
    tasks.each do |task|
        threads << Thread.new {
            executing = false
            while true
                sleep(0.5)
                task = Task.find_by(short: task.short)
                if not(executing)
                    diff = task.time - Time.now
                    seconds = (diff / 1.second).round + 3600
                    puts "#{task.time} - #{Time.now} = #{seconds}"
                    if seconds > 0 && seconds < 2
                        executing = true
                        initiate(task)
                        executing = false
                    elsif seconds < 0
                        puts "<0"
                        # Increment day index of task execution if it has just been run 
                        task.update(time: task.time.change(day: task.time.day + 1))
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