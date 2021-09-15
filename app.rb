require './models/init.rb'
require 'bcrypt'


def current_user
  if session[:user_id]
     user = User.find(id: session[:user_id])
  else
   nil
  end
end
   

class App < Sinatra::Base
  enable :inline_templates
  enable :sessions
  set :method_override, true

  

  get '/' do
    if current_user
      @name =current_user.name
      erb :hello_template
    else
      redirect '/login'
    end
  end

  get '/login' do
    erb :login
  end






  post '/adduser' do
    data = request.body.read
    cc = BCrypt::Password.create(params[:clave])
    user = User.new(name: params[:usuario] ,password:cc)
    if user.save
      session.clear
      session[:user_id]=user.id
      [201, { 'Location' => "users/#{user.id}" }, 'created']
      @name="usuario agregado exitosamente!!"
      erb :hello_template

    else
      [500, {}, 'Internal Server Error']
    end
  end

 
  post '/login' do
    data = request.body.read
    @user = User.find(name: params[:usuario])
    @db_password = BCrypt::Password.new(@user.password)
    @clave= params[:clave]
    if BCrypt::Password.new(@db_password) == @clave
      session.clear
      session[:user_id]=@user.id
      @name = "Password CORRECTO"
      erb :hello_template
    else
      @name = "Password INCORRECTO"
      erb :hello_template
        
    end
  end

  post '/logout' do 
    session[:user_id] = nil 
    @name = "No existe sesión activa"
    erb :hello_template
  end

    
end

#ejemplo sesiones
#https://www.iteramos.com/pregunta/45697/lo-que-es-un-simple-esquema-de-autenticacion-para-sinatrarack
#https://gist.github.com/tomdalling/b873e731e5c6c56431807d40a904f6cf













