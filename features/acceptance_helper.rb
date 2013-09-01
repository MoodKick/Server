ENV['RAILS_ENV'] ||= 'acceptance'
# encoding: UTF-8
require 'spec_helper'
require 'steak'

require 'selenium/webdriver'
# Put your acceptance spec helpers inside spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Capybara.register_driver :selenium do |app|
  #FIXME: somehow 'chrome' doesn't open any page, thus switched to firefox
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

Capybara.default_driver = :selenium

Capybara.default_host = 'lvh.me'
Capybara.server_port = 4000 # could be any of your choice
Capybara.app_host = "http://lvh.me:#{Capybara.server_port}"

def registration_service
  repository = nil
  RegistrationService.new(repository)
end
