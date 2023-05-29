

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'

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


enable :sessions

get '/items' do
  items = conn.exec('SELECT * FROM items').to_a
  items.to_json
end

post '/items' do
  coolnewitem = JSON.parse(request.body.read)
  connection.exec_params('insert into items (name, price) VALUES ($1, $2)', [coolnewitem[name], coolnewitem[price]])
  status 201
end

delete '/items/:id' do
  @item = Item.find_by_id(params[:id])
  if @item
    @item.destroy
  else
    halt 404, "item not found IDIOT"
  end
end

post '/user' do
  coolnewuser = JSON.parse(request.body.read)
  connection.exec_params('insert into user (username, password) VALUES ($1, $2)', [coolnewuser[username], coolnewuser[password]])
  return username
end

get '/user/:id' do
  user = conn.exec('SELECT * FROM user WHERE User.id=$1 ').to_a, [params[:id]]
  user.to_json
end




