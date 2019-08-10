  #ライブラリの読み込み
  require 'sinatra'
  require 'sinatra/reloader'
  require 'fileutils'
  require 'sinatra/cookies' 
  require 'pg'
  

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
      redirect 'index'
  end
end

  get '/index' do
    active_user = session[:user_id]
    @posts = db.exec_params("SELECT * FROM posts")
    
    erb :index
  end

  get '/post' do
    erb :post
  end

  post '/post' do
    active_user = session[:user_id]
    content = params[:content]
    name = params[:name]
    db.exec_params("INSERT INTO posts(name,content) VALUES($1,$2)",[name,content])
   
    redirect '/index'
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
      redirect '/sign_up'
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
      redirect '/'
    end
  end

  

  





#   #Sinatraの設定
#   set :public_folder, 'public'
#   enable :sessions

  

#   get '/hello' do
#     # query string から取得
#     # @name = params[:name]
#     session[:name] =  params[:name]

#     erb :hello
# end

  



#   get '/read' do
#     if session[:name].nil? 
#       "<h1>あなたは誰ですか？</h1>"
#     else
#       "<h1>ようこそ#{session[:name]}</h1>"
#     end
#   end
  

#   get '/user/:user_name' do 
#     user_name = params[:user_name]
#     "<h1>User: #{user_name}!</h1>"
#   end



#   get '/time' do
#     Time.now.to_s
#   end

#   get '/form' do
#     erb :form
#   end

#   post '/form_output' do
#     @name = params[:name]
#     @email = params[:email]
#     @content = params[:content]

# #   File.open("form.txt", mode = "a") {|f|
# #     f.write("#{@name},#{@email},#{@content}\n")
# #   }
 
# #     erb:form_output
# # end

# #   get '/upload' do
# #     @images = Dir.glob("./public/images/*").map{|path| path.split('/').last }
# #    erb :upload
# #   end
 

# #   post '/upload' do
# #     @file_name = params[:img][:filename]
# #     FileUtils.mv(params[:img][:tempfile], "./public/images/#{@file_name}")
# #     # erb :uploaded
# #     redirect '/upload'
# #    end
  
   

   
  

  

  

  
#   # get '/form' do
#   #   erb :form
#   # end






