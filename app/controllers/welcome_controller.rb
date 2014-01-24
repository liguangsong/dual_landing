class WelcomeController < ApplicationController
  require 'will_paginate/array'

  def index
    @code_1=Zoo.first[:number]
    code=@code_1.to_i;
    session[:code]=@code_1
    zoo=Zoo.first
    zoo[:number]=code+1
    zoo.save()
    @url="192.168.1.182:3001/sessions/new/"+@code_1
  end

  def show
    @code=session[:code]
    message=RestClient.post '192.168.1.182:3001/sessions_login_show', :nested => {:param1 => @code}
    message2=JSON.parse(message)
    @user=message2["user"]
    @disabled=message2["disabled"]
    @activity=message2["activity"].paginate(page: 1, per_page: 10)
  end

  def login
    status=RestClient.post '192.168.1.182:3001/sessions_login_status', :nested => {:param1 => params["code"]}
    respond_to do |format|
      format.json { render :json => status }
    end
  end


end

