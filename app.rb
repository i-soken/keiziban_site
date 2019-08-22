  #ライブラリの読み込み
  require 'sinatra'
  require 'sinatra/reloader'
  require 'fileutils'
  require 'sinatra/cookies' 
  require 'pg'
  

  set :public_folder, 'public'
  enable :sessions


  def db
    host = 'localhost'
    user = 'zujianyuye' #自分のユーザー名を入れる
    password = ''
    dbname = 'skboard'
  
    # PostgreSQL クライアントのインスタンスを生成
    PG::connect(
    :host => host,
    :user => user,
    :password => password,
    :dbname => dbname)
  end

  get '/' do
    if 
      session[:user_id].nil? == true
      erb :home
    else
      redirect '/sign_in'
  end
end

  get '/index' do
    if session[:user_id].nil? == true
      redirect '/sign_in'
    else
    @images = db.exec_params('select * from images')
    erb :index
  end
end

  get '/post' do
    erb :post
  end

  post '/post' do
    if 
      session[:user_id].nil? == true
      redirect '/sign_in'
    else
    users_name = db.exec("SELECT name FROM users WHERE id = $1",[session[:users_id]]).first
    name = params[:name]
    content = params[:content]
    @file_name = params[:img][:filename]
    FileUtils.mv(params[:img][:tempfile], "./public/images/#{@file_name}")
    db.exec_params("INSERT INTO images(name,content,image,user_id) VALUES($1,$2,$3,$4)",[name,content,@file_name,session[:user_id],])
    redirect '/index'
  end
end

  
  get '/sign_up' do
    erb :sign_up
  end

  post '/sign_up' do
    name = params[:name]
    email = params[:email]
    password = params[:password]
    res = db.exec_params("select * from users where name = $1 and email = $2",[name, email]).first 
    unless res
      db.exec_params("INSERT INTO users(name,email,password) VALUES($1,$2,$3)",[name,email,password])
      redirect '/sign_in'
    else
      redirect '/already_sign_up'
  end
end


  get '/sign_in' do
    erb :sign_in
  end


  post '/sign_in' do
    name = params[:name]
    password = params[:password]
    puts "hello"
    id = db.exec_params("SELECT id FROM users WHERE name =$1 AND password = $2",[name,password]).first
    if id
      session[:user_id] = id['id']
      redirect '/index'
    else
      redirect '/yet_sign_up'
    end
  end
 
  get '/already_sign_up' do
    erb :already_sign_up
  end

  get '/yet_sign_up' do
    erb :yet_sign_up
  end

  post '/del/:id' do
  if session[:user_id] == db.exec("SELECT user_id FROM images WHERE id = $1",[params[:id]]).first()["user_id"]
    db.exec("DELETE FROM images where id = $1",[params[:id]])
    erb :del
  else
    redirect '/index'
  end
end

post '/follow/:id' do
id = params[:id]
if id == db.exec("SELECT followed FROM follows")
  db.exec("INSERT INTO follows(following,followed) VALUES($1,$2)",[session[:user_id],params[:id]])
  redirect '/index'
else
  erb :following
  end
end

post '/unfollow/:id' do
id = params[:id]
if db.exec("SELECT * FROM follows WHERE following = $1 AND followed = $2",[session[:user_id],params[:id]])
   db.exec("DELETE FROM follows where id = $1",[params[:id]])
   erb :unfollow
else
  redirect '/index'
  end
end

