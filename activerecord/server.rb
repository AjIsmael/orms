require "sinatra/activerecord"
require "sinatra"

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database:"./database.sqlite3")
#set :database, {adapter: "sqlite3", database: "./database.sqlite3"}
enable :sessions

class User < ActiveRecord::Base
end

get "/" do
  puts "Running"
  erb :home
end

get "/signup" do
  @user = User.new
  erb :'users/signup'
end

post '/signup' do
  @user = User.new(params)
  if @user.save
    p "#{@user.first_name} was saved to the database"
  end
  erb :'users/thanks'
end

get '/thanks' do
  erb :'users/thanks'
end

get '/login' do
  if session[:user_id]
    redirect '/'
  else
    erb :'users/login'
  end
end

post '/login' do
  given_password = params[:password]
  user = User.find_by(email:params[:email])
  if user
    if user.password == given_password
      p "user authenticated successfully"
      session[:user_id] = user.id
    else
      p "invalid password"
    end
  end
end

# Delete request
post '/logout' do
  session.clear
  p 'user logged out successfully'
  redirect '/'
end
# MVC
