require 'selenium-webdriver'

class DashboardController < ApplicationController
  def show
    @tasks = Task.all
  end
end
