class ReportMailer < ApplicationMailer
    def send_report_email(task, user, style, variables)
        puts variables
        @task = task
        @user = user
        variable = style[/%(.*?)%/m, 1]
        begin
            result = variables.find { |v| v['title'] == variable }['value']
        rescue => exception
            task.errors.push({time: Time.now, message: "ERROR: variable '#{variable}' cannot be found! (Check your email methods)"})
        end
        @message = style.gsub("%#{variable}%", result)    
        mail(to: "natebvsd@gmail.com", subject: "A scraper report is available!")
    end
end
