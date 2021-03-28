require 'selenium-webdriver'

namespace :scraper do

    desc 'Scrapes and interacts with webpages based on user methods'
    task :scrape, [:task_short] => [:environment] do |t, args|

        puts "Scraping from #{args[:task_short]}"

        options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'no-sandbox'])
        driver = Selenium::WebDriver.for(:chrome, options: options)

        wait = Selenium::WebDriver::Wait.new(:timeout => 10)

        elm = nil

        task = Task.find_by(short: args[:task_short])
        task.task_methods.each do |method|
            sleep(method.delay)
            if method.action_type === "GET"
                puts method.action
                driver.get(method.action)
            elsif method.action_type === "find"
                if method.action[0] === "." && elm != nil
                    elm = wait.until { elm.find_element(:xpath, method.action) }
                else
                    elm = wait.until { driver.find_element(:xpath, method.action) }
                end
            elsif method.action_type === "click"
                elm.click()
            elsif method.action_type === "type"
                elm.send_keys(method.action)
            end
        end

        driver.quit
    end
end