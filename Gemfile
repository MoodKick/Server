source 'https://rubygems.org'
gem 'rails', '3.2.3'

gem 'devise', '>= 2.1.0'
gem 'cancan', '>= 1.6.7'
gem 'will_paginate', '>= 3.0.3'

gem 'em-websocket'
gem 'pg'
gem 'carrierwave'

gem 'dim', git: 'https://github.com/subelsky/dim.git'

# use branch until https://github.com/rails/jbuilder/issues/20 is resolved
gem 'jbuilder', git: 'https://github.com/bigjason/jbuilder.git'

group :development do
  gem 'capistrano'
  gem 'rvm-capistrano'
end

group :development, :test, :acceptance do
  gem 'debugger'
  gem 'rspec-rails', '>= 2.10.1'
  gem 'factory_girl_rails', '>= 3.3.0'
end

group :test, :acceptance do
  #'WebDriver is a tool for writing automated tests of websites. It aims to mimic the behaviour of a real user, and as such interacts with the HTML of the application.'
  gem 'selenium-webdriver', '~> 2.24.0'
  #'The delicious combination of RSpec and Capybara for Acceptance BDD'
  gem 'steak'
  #'Behaviour Driven Development framework'
  #'Strategies for cleaning databases in Ruby. Can be used to ensure a clean state for testing.'
  gem 'database_cleaner'
  gem 'timecop'
  gem 'email_spec', '>= 1.2.1'
end

group :assets do
  gem 'twitter-bootstrap-rails'
  gem 'wysihtml5-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
end
