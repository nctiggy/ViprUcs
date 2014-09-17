class HostsController < ApplicationController
  def index
  end

  def create
    puts add_host(params[:host], cookies[:auth_token], to_boolean(cookies[:use_cert]), cookies[:base_url], cookies[:tenant_uid])
  end

  def new
    #New Host Form
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
  
  def add_host(payload, auth_token, verify_cert, base_url, tenant_uid)
     RestClient::Request.execute(method: :post,
       url: "#{base_url}/tenants/#{tenant_uid}/hosts",
       verify_ssl: verify_cert,
       payload: payload,
       headers: {
         :'X-SDS-AUTH-TOKEN' => auth_token,
         content_type: 'application/json',
         accept: :json
       })
  end
  
  def to_boolean(str)
    str.to_s.downcase == "true"
  end
end
