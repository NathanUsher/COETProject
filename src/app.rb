require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'
configure do
  set :port,4567
  set :bind, '0.0.0.0'
end


db_host = ENV['dbuser']
db_user = ENV['dbuser']
db_password = ENV['dbpass']
db_name = ENV['dbname']

connection = PG.connect(host: db_host, user: db_user, password: db_password, dbname: db_name)