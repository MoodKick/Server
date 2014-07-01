server
======

## First steps

1. Install and configure PostgreSQL 9.1+
  1. Run `postgres -V` to see if you already have it.
  1. Make sure that the server's messages language is English; this is [required](https://github.com/rails/rails/blob/3006c59bc7a50c925f6b744447f1d94533a64241/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L1140) by the ActiveRecord Postgres adapter.
2. Install libxml2, g++, and make.
3. Install rvm
4. Clone the project
5. Cd project folder and install Ruby 1.9.3 as rvm suggests.
6. Install Bundler
7. Copy `config/database.yml.sample` to `config/database.yml`. Edit the file to point to your postgres instance.
9. Create the "moodkick" user

## Before you start Rails

1. `bundle install`
2. `bundle exec rake db:create db:migrate db:test:prepare db:seed`
3. Try running tests: `bundle exec rake`
4. `bundle exec rails server`

You should now be able to connect to rails on [http://localhost:3000](http://localhost:3000)
