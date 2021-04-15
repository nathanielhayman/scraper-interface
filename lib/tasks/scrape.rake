require 'selenium-webdriver'

def initiate(task)
    puts "[#{Time.now}] Executing task \##{task.id} ~ #{task.short}..."
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'no-sandbox'])
    driver = Selenium::WebDriver.for(:chrome, options: options)
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

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
end

def run_threads(tasks) 
    threads = []
    tasks.each do |task|
        threads << Thread.new { 
            puts task.time
            if task.time - Time.now < 1000
                puts "#{task.time} - #{Time.now} < 1000"
                initiate(task)
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