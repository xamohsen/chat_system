class ChatAppController < ApplicationController

  # POST /application
  def create
    if params and params[:app]
      params[:app][:token] = (ChatApp.all.count + 1)
    end
    @chat_app = ChatApp.create!(chat_app_params)
    json_response(@chat_app, :created)
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
      params.require(:app).permit(:name, :token)
    end
  end

  def set_chat_app
    @chat_app = ChatApp.find_chat_app(params[:id])
  end

end
