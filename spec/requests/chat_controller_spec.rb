require 'rails_helper'


def initialize_data
  @temp_chat_app = FactoryBot.create(:chat_app)
  100.times do
    FactoryBot.create :chat, chat_app_id: @temp_chat_app[:id]
  end
end

RSpec.describe ChatController, type: :request do

  describe "GET" do
    before (:all) do
      initialize_data
    end
    describe 'GET /applications/token/chats' do
      before (:all) do
        get "/applications/#{@temp_chat_app[:token]}/chats"
      end
      it 'returns chat_apps' do
        expect(json).not_to be_empty
        expect(json.size).to eq(100)
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'should not return the apps id' do
        json.each {|app| expect(app['id']).to eq(nil)}
      end
    end

    describe "GET /applications/:token/chats/:number" do
      context 'when the request is valid' do
        before (:all) do
          @chat = FactoryBot.create :chat, chat_app_id: @temp_chat_app[:id]
          get "/applications/#{@temp_chat_app[:token]}/chats/#{@chat[:number]}"
        end
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns chat number, messages count and chat_app_id' do
          expect(json["number"]).to eq(@chat[:number])
          expect(json['messages_count']).to eq(@chat[:messages_count])
          expect(json['chat_app_id']).to eq(@chat[:chat_app_id])
        end
        it 'should not return chat id' do
          expect(json["id"]).to eq(nil)
        end

        after (:all) do
          Chat.delete_all
        end
      end

      context 'when the request is invalid' do
        it 'returns status code 404 #1' do
          get "/applications/#{0}/chats/#{0}"
          expect(response).to have_http_status(404)
        end
        it 'returns status code 404 #2' do
          @chat = FactoryBot.create :chat, chat_app_id: @temp_chat_app[:id]
          get "/applications/#{0}/chats/#{@chat[:number]}"
          expect(response).to have_http_status(404)
        end
        it 'returns status code 404 #3' do
          get "/applications/#{@temp_chat_app[:token]}/chats/#{0}"
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
      before (:all) do
        @temp_chat_app = FactoryBot.create(:chat_app)
        post "/chat/", params: {chat: {chat_app_token: @temp_chat_app[:token]}}
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end
      it 'returns chat_app name and token +1 after creation' do
        expect(json['messages_count']).to eq(0)
        expect(json['number']).to eq(1)
      end
      it 'returns chat_app name and token +2  after creating another app' do
        post "/chat/", params: {chat: {chat_app_token: @temp_chat_app[:token]}}
        expect(response).to have_http_status(201)
        expect(json['messages_count']).to eq(0)
        expect(json['number']).to eq(2)
      end
      it 'should not return the app id' do
        expect(json['id']).to eq(nil)
      end
      after (:all) do
        ChatApp.delete_all
      end
    end

    context 'when the request is invalid' do
      before {post "/chat/", params: {chat: {}}}
      it 'returns status code 422' do
        expect(response).to have_http_status(404)
      end
      it 'returns a validation failure message' do
        expect(response.body).to match("not fond")
      end
      it 'returns error request#1' do
        post "/chat/"
        expect(response.body).to match("not fond")
        expect(response).to have_http_status(404)
      end
      it 'returns error request#2' do
        post "/chat/", params: {}
        expect(response.body).to match("not fond")
        expect(response).to have_http_status(404)
      end

    end
  end

end
