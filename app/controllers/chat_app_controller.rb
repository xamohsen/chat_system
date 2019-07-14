class ChatAppController < ApplicationController

  # POST /application
  def create
    chat_app_params[:token] = ChatApp.all.count+1
    puts chat_app_params
    @todo = ChatApp.create!(chat_app_params)
    json_response(@todo, :created)
  end

  # GET /applications
  def index
    @chat_apps = ChatApp.all
    json_response(@chat_apps)
  end

  # GET /application/:id
  def show
    set_chat_app
    json_response(@chat_app)
  end


  private

  def chat_app_params
    # whitelist params
    params.require(:name)
  end

  def set_chat_app
    @chat_app = ChatApp.find_chat_app(params[:id])
  end
end
