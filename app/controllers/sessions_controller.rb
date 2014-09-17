require 'restclient'
require 'json'

class SessionsController < ApplicationController
  rescue_from RestClient::Unauthorized, with: :unauthorized_user
  def login
    #redirect_to action: :info if cookies[:auth_token]
  end

  def info
    @user_name = cookies[:user_name]
    cookies[:tenant_uid] = JSON.parse(who_am_i(cookies[:auth_token], to_boolean(cookies[:use_cert]), cookies[:base_url]))['tenant']
    @tenant_uid = cookies[:tenant_uid]
    @auth_token = cookies[:auth_token]
  end

  def login_attempt
    cookies.permanent[:use_cert] = params[:login][:use_cert] == 1 ? TRUE : FALSE
    puts params[:login].class
    cookies.permanent[:server_name] = params[:login][:server_name]
    cookies.permanent[:user_name] = params[:login][:user_name]
    cookies[:base_url] = generate_base_url(cookies[:server_name])
    auth_token = get_auth_token(cookies[:user_name], params[:login][:password], cookies[:use_cert], cookies[:base_url])
    if auth_token.code == 200
      cookies[:auth_token] = { value: auth_token.headers[:x_sds_auth_token], expires: 8.hours.from_now}
      #cookies[:tenant_uid] = Vipruby.get_tenant_uid(cookies[:base_url], cookies[:auth_token], cookies[:use_cert?])
      flash[:notice] =  "Welcome to Zombocom, #{params[:login][:user_name]}"
      redirect_to action: :info
    else
      flash.now[:alert] = "Something is incorrect... #{auth_token.code}"
      redirect_to action: :login
    end
  end
  
  def get_auth_token(user_name, password, verify_cert, base_url)
    RestClient::Request.execute(method: :get,
      url: "#{base_url}/login",
      user: user_name,
      password: password,
      verify_ssl: verify_cert,
      headers: {
        accept: :json
      }
    )
  end
  
  def who_am_i(auth_token, verify_cert, base_url)
      RestClient::Request.execute(method: :get,
        url: "#{base_url}/user/whoami",
        verify_ssl: FALSE,
        headers: {
          :'x_sds_auth_token' => auth_token,
          accept: :json
        }
      )
  end
  
  def unauthorized_user
    flash.now[:alert] = "You shall not pass"
    redirect_to action: :login
  end
  
  def to_boolean(str)
    str.to_s.downcase == "true"
  end
  
  def generate_base_url(ip_or_fqdn)
    "https://#{ip_or_fqdn}:4443"
  end

end