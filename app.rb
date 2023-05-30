
require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'
require "sinatra/json"
require 'sinatra/param'

configure do
  set :port,4567
  set :bind, '0.0.0.0'
end


db_host = ENV['DB_HOST']
db_user = ENV['DB_USER']
db_password = ENV['DB_PASSWORD']
db_name = ENV['DB_NAME']
sleep 2
connection = PG.connect(host: db_host, user: db_user, password: db_password, dbname: db_name)


connection.exec('CREATE TABLE IF NOT EXISTS usr (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), username varchar(255), password varchar(255));');
connection.exec('CREATE TABLE IF NOT EXISTS items (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), name varchar(255), price integer);');


enable :sessions

get '/items' do
  content_type :json
  items = connection.exec('SELECT * FROM items').to_a
  json items
end

post '/items' do
  content_type :json

  data = JSON.parse request.body.read
  puts data
  
  connection.exec_params('insert into items (name, price) VALUES ($1, $2)', [data["name"], data["price"]])
  
  status 204
end

delete '/items/:id' do
  content_type :json
  puts params
    halt 404, "item not found IDIOT"
  connection.exec_params('DELETE FROM items where id = $1', [params[:id]])
  status 201
end

post '/user' do
  content_type :json
  data = JSON.parse request.body.read
  connection.exec_params('insert into usr (username, password) VALUES ($1, $2)', [data["username"], data["password"]])
  status 204
end

get '/user/:id' do
  content_type :json
  user = connection.exec('SELECT * FROM usr ').to_a
  json user
end




