require 'selenium-webdriver'

def initiate(task)
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'no-sandbox'])
    driver = Selenium::WebDriver.for(:chrome, options: options)
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    elm = nil
    task = Task.find_by(short: args[:task_short])
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

namespace :task_module do

    desc 'Scrapes and interacts with webpages based on user methods'
    task :run, [:task_short] => [:environment] do |t, args|

        puts "[#{Time.now}] Running tasks..."

        threads = []
        Task.all.each do |task|
            threads << Thread.new { 
                if Time.now - task.time < 2
                    initiate(task)
                end
            }
        end
        threads.each(&:join)
    end
end