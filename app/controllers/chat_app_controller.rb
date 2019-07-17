class ChatAppController < ApplicationController

  # POST /application
  def create
    if params and params[:app]
      params[:app][:token] = (ChatApp.all.count + 1)
      params[:app][:chats_count] = 0
    end
    @chat_app = ChatApp.create!(chat_app_params)
    json_response(@chat_app, :created)
  end


  def update
    if params and params[:app]
      @chat_app = ChatApp.find_by token: params[:app][:token]
      @chat_app.update(name: params[:app][:name])
      json_response(@chat_app, :ok)
    else
      json_response(nil, :not_found)
    end
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
    if params and params[:app]
      params.require(:app).permit(:name, :token, :chats_count)
    end
  end

  def set_chat_app
    @chat_app = ChatApp.find_chat_app(params[:token])
  end

end
