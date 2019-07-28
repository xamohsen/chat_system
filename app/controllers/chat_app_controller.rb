class ChatAppController < ApplicationController

  # POST /application
  def create
    if validate_create_request params
      if $redis.get('apps_count') == nil
        $redis.set('apps_count', ChatApp.count() + 1)
      end
      params[:app][:token] = $redis.get('apps_count').to_i
      $redis.incr('apps_count')
      params[:app][:chats_count] = 0
      messaging_service.publish(params[:app].to_json)
      json_response(params[:app], :created)
    else
      json_response(nil, :created)

    end

  end

  def validate_create_request(params)
    return params != nil && params[:app] != nil && params[:app][:name] != nil
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
