class ChatAppController < ApplicationController
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
    params.permit(:token, :name)
  end

  def set_chat_app
    @chat_app = ChatApp.find_chat_app(params[:id])
  end
end
