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

enable :sessions

get '/items' do
  items = conn.exec('SELECT & FROM items').to_a
  items.to_json
end

post '/items' do
  coolnewitem = JSON.parse(request.body.read)
  status 201
end

delete '/items:/id' do
  @item = Item.find_by_id(params[:id])
  if @item
    @item.destroy
  else
    halt 404, "item not found IDIOT"
end

