class XtremioController < ApplicationController
  require 'heybulldog'
  require 'rest-client'
  
  def new
    
  end
  
  def create
    
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def hello
    @user = cookies[:user_name]
  end
  
  def destroy
    
  end
  
  def login
    
  end
  
  def index
    @dog = JSON.parse(RestClient::Request.execute(method: :get,
         url: "https://nijikokun-thedogapi.p.mashape.com/random",
         headers: {
           :'X-Mashape-Key' => "rThSWBUN14mshhOznhJP3LsQCkfQp1vT0wJjsnyVTQE8nJ9Q44",
           accept: :json
         }))
  end
  
  def generate_token
    cookies[:user_name] = { value: params[:login][:user_name], expires: 8.hours.from_now }
    cookies[:password] = { value: params[:login][:password], expires: 8.hours.from_now }
    redirect_to action: 'hello'
  end
end
