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
    elms = []
    in_logic = []
    result = false

    task.task_methods.each do |method|
        if method.delay
            sleep(method.delay)
        end
        case method.action_type
        when "GET"
            if !in_logic[0] || (in_logic[0] && result)
                puts "Begin get method"
                if method.action.include? "https://"
                    driver.get(method.action)
                else
                    driver.get("https://" + method.action)
                end
            end
        when "find"
            if !in_logic[0] || (in_logic[0] && result)
                puts "Begin find method"
                if method.action[0] === "." && elm != nil
                    begin
                        elms = wait.until { elm.find_elements(:xpath, method.action) }
                        if !elms[0]
                            errors.push({time: Time.now, message: "ERROR: Could not find the element at '#{method.action}'"})
                        end
                    rescue => exception
                        errors.push({time: Time.now, message: "ERROR: The scraper encountered the following exception during execution: #{exception} [#{task.title} : ##{task.task_methods.find_index(method)+1}]"})
                    end
                else
                    begin
                        elms = wait.until { driver.find_elements(:xpath, method.action) }
                        if !elms[0]
                            errors.push({time: Time.now, message: "ERROR: Could not find the element at '#{method.action}'"})
                        end
                    rescue => exception
                        errors.push({time: Time.now, message: "ERROR: The scraper encountered the following exception during execution: #{exception} [#{task.title} : ##{task.task_methods.find_index(method)+1}]"})
                    end
                end
                puts elms[0]
            end
        when "click"
            if !in_logic[0] || (in_logic[0] && result)
                if elm != nil
                    begin
                        elm.click() 
                    rescue => exception
                        errors.push({time: Time.now, message: "ERROR: The scraper encountered the following exception during execution: #{exception} [#{task.title} : ##{task.task_methods.find_index(method)+1}]"})
                    end
                else
                    errors.push({time: Time.now, message: "ERROR: There is no element available to click! [#{task.title} : ##{task.task_methods.find_index(method)+1}]"})
                end
            end
        when "type"
            if !in_logic[0] || (in_logic[0] && result)
                if elm != nil
                    begin
                        elm.send_keys(method.action) 
                    rescue => exception
                        errors.push({time: Time.now, message: "ERROR: The scraper encountered the following exception during execution: #{exception} [#{task.title} : ##{task.task_methods.find_index(method)+1}]"})
                    end
                else
                    errors.push({time: Time.now, message: "ERROR: There is no element available to click! [#{task.title} : ##{task.task_methods.find_index(method)+1}]"})
                end
            end
        when "logic"
            if !in_logic[0] || (in_logic[0] && result)
                in_logic.push(true)
                if method.action && method.modifier && method.mod_val
                    variable1 = variables.find { |v| v['title'] == method.action }['value']
                    variable2 = nil
                    intermediate = variables.find { |v| v['title'] == method.modifier }
                    if intermediate == nil
                        variable2 = method.modifier
                    else
                        variable2 = intermediate['value']
                    end
                    puts method.mod_val
                    case method.mod_val
                    when ">"
                        begin
                            if variable1 > variable2
                                result = true
                            else
                                result = false
                            end
                        rescue => exception
                            
                        end
                    when "<"
                        begin
                            if variable1 < variable2
                                result = true
                            else
                                result = false
                            end
                        rescue => exception
                            
                        end
                    when "="
                        begin
                            puts "AAA"
                            puts "#{variable1}, #{variable2}"
                            puts "#{variable1 == variable2}"
                            if variable1 == variable2
                                result = true
                            else
                                result = false
                            end
                        rescue => exception
                            
                        end
                    else
                        return
                    end

                    puts result

                end
            end
        when "save as"
            if !in_logic[0] || (in_logic[0] && result)
                puts "Begin save method"
                if variables.map { |j| j['title'] if j['title'] == method.action } != nil
                    if elm || elms
                        if method.modifier
                            case method.modifier
                            when "content"
                                begin
                                    current_data.push({ time: Time.now, variable: method.action, result: "#{elm}" })
                                    variables[variables.find_index(variables.find {|v| v["title"] == method.action})]["value"] = elm
                                rescue => exception
                                    errors.push({time: Time.now, message: "ERROR: The scraper encountered the following exception during execution: #{exception} [#{task.title} : ##{task.task_methods.find_index(method)+1}]"})
                                end
                            else
                                begin
                                    current_data.push({ time: Time.now, variable: method.action, result: "#{elm.attribute(method.modifier)}" })
                                    variables[variables.find_index(variables.find {|v| v["title"] == method.action})]["value"] = elm.attribute(method.modifier)
                                rescue => exception
                                    errors.push({time: Time.now, message: "ERROR: The scraper encountered the following exception during execution: #{exception} [#{task.title} : ##{task.task_methods.find_index(method)+1}]"})
                                end
                            end
                        else
                            current_data.push({ time: Time.now, variable: method.action, result: "#{elm}" })
                        end
                    else
                        errors.push({time: Time.now, message: "ERROR: Could not find an element to assign variable #{method.action} to. [#{task.title} : ##{task.task_methods.find_index(method)+1}]"})
                        break
                    end
                else
                    errors.push({time: Time.now, message: "ERROR: Could not find the variable #{method.action}! [#{task.title} : ##{task.task_methods.find_index(method)+1}]"})
                    break
                end
            end
        when "end logic"
            puts "endl"
            in_logic = in_logic - [true]
            puts in_logic
        when "email"
            if !in_logic[0] || (in_logic[0] && result)
                puts "sending email to #{method.action}"
                ReportMailer.send_report_email(task, method.action, method.modifier, variables).deliver
            end
        end

        if elms[0]
            elm = elms[0]
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