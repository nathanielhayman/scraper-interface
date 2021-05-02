class ReportMailer < ApplicationMailer
    def send_report_email(task, user, style, variables)
        @task = task
        @user = user
        variable = style[/%(.*?)%/m, 1]
        result = variables.find { |v| v['title'] == variable }['value']
        @message = style.gsub("%#{variable}%", result)    
        mail(to: "natebvsd@gmail.com", subject: "A scraper report is available!")
    end
end
