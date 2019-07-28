require 'rails_helper'


def initialize_chat_data
  @app = create :chat_app
  100.times do
    FactoryBot.create :chat, app_token: @app[:token]
  end
end

RSpec.describe ChatController, type: :request do

  describe "GET" do
    before :all do
      initialize_chat_data
    end
    describe 'GET /applications/:app_token/chats' do
      before :all do
        get "/applications/#{@app[:token]}/chats"
      end
      it 'returns chats' do
        expect(json).not_to be_empty
        expect(json.size).to eq(100)
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'should not return the apps id' do
        json.each {|chat| expect(chat['id']).to eq(nil)}
      end
    end

    describe "GET /applications/:token/chats/:number" do
      context 'when the request is valid' do
        before :all do
          @chat = FactoryBot.create :chat, app_token: @app[:token]
          get "/applications/#{@app[:token]}/chats/#{@chat[:chat_number]}"
        end
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns chat number, messages count and chat_app_id' do
          expect(json["chat_number"]).to eq(@chat[:chat_number])
          expect(json['messages_count']).to eq(@chat[:messages_count])
          expect(json['app_token']).to eq(@chat[:app_token])
        end
        it 'should not return chat id' do
          expect(json["id"]).to eq(nil)
        end

        after :all do
          Chat.delete_all
        end
      end

      context 'when the request is invalid' do
        it 'returns status code 404 #1' do
          get "/applications/#{0}/chats/#{0}"
          expect(response).to have_http_status(404)
        end
        it 'returns status code 404 #2' do
          @app = create :chat_app
          @chat = create :chat, app_token: @app[:token]
          get "/applications/#{0}/chats/#{@chat[:chat_number]}"
          expect(response).to have_http_status(404)
        end
        it 'returns status code 404 #3' do
          @app = create :chat_app
          get "/applications/#{@app[:token]}/chats/#{0}"
          expect(response).to have_http_status(404)
        end
      end
    end

    after(:all) do
      ChatApp.delete_all
    end

  end
  describe "Post /chat/" do

    context 'when the request is valid' do
      before :all do
        @chat_app = create :chat_app
        post "/chat/", params: {chat: {app_token: @chat_app[:token]}}
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end
      it 'should update chat_app chats count' do
        @chat_app = ChatApp.find @chat_app[:id]
        expect(@chat_app[:chats_count]).to eq(1)
      end
      it 'returns chat_app name and token +1 after creation' do
        expect(json['messages_count']).to eq(0)
        expect(json['chat_number']).to eq(1)
      end
      it 'returns chat_app name and token +2  after creating another app' do
        post "/chat/", params: {chat: {app_token: @chat_app[:token]}}
        expect(response).to have_http_status(201)
        expect(json['messages_count']).to eq(0)
        expect(json['chat_number']).to eq(2)
      end
      it 'should not return the app id' do
        expect(json['id']).to eq(nil)
      end
      after :all do
        ChatApp.delete_all
      end
    end

    context 'when the request is invalid' do
      before {post "/chat/", params: {chat: {}}}
      it 'returns status code 422' do
        expect(response).to have_http_status(404)
      end
      it 'returns a validation failure message' do
        expect(response.body).to match("Request Error")
      end
      it 'returns error request#1' do
        post "/chat/"
        expect(response.body).to match("Request Error")
        expect(response).to have_http_status(404)
      end
      it 'returns error request#2' do
        post "/chat/", params: {}
        expect(response.body).to match("Request Error")
        expect(response).to have_http_status(404)
      end

    end
  end

end
