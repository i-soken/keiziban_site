
  require 'sinatra'
  require 'sinatra/reloader'

  get '/' do
    'hello logoon!!!'
  end
  
  get '/hello' do 
    name = params[:name]
    "<h1>Hello #{name}!</h1>"
  end

  get '/time' do
    Time.now.to_s
  end

  get '/user/:user_name' do 
    user_name = params[:user_name]
    "<h1>Hello #{user_name}!</h1>"
  end