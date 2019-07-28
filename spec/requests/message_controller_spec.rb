require 'rails_helper'

def initialize_message_data
  @temp_chat_app = create :chat_app
  @chat = create :chat, app_token: @temp_chat_app[:token]
  @message = create :message,
                    chat_number: @chat[:chat_number],
                    app_token: @temp_chat_app[:token]
  99.times do
    FactoryBot.create :message,
                      chat_number: @chat[:chat_number],
                      text: "text message",
                      app_token: @temp_chat_app[:token]
  end
end

RSpec.describe MessageController, type: :request do

  describe "Search" do
    before :all do
      initialize_message_data
      get "/messages/search/#{@temp_chat_app[:token]}/#{@chat[:chat_number]}/text"
    end

    it 'returns messages not empty' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

  end

  describe "GET" do
    before :all do
      initialize_message_data
    end
    describe 'GET /applications/:app_token/chats/:chat_number/messages' do
      before :all do
        get "/applications/#{@temp_chat_app[:token]}/chats/#{@chat[:chat_number]}/messages"
      end
      it 'returns chat_apps' do
        expect(json).not_to be_empty
        expect(json.size).to eq(100)
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'should not return the message id' do
        json.each {|message| expect(message['id']).to eq(nil)}
      end
    end
    describe "GET /applications/:app_token/chats/:chat_number/messages/:message_number" do
      context 'when the request is valid' do
        before :all do
          get "/applications/#{@temp_chat_app[:token]}/chats/#{@chat[:chat_number]}/messages/#{@message[:message_number]}"
        end
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns message number, text count and chat_id' do
          expect(json["message_number"]).to eq(@message[:message_number])
          expect(json['text']).to eq(@message[:text])
          expect(json['chat_number']).to eq(@message[:chat_number])
        end
        it 'should not return chat id' do
          expect(json["id"]).to eq(nil)
        end
      end

      context 'when the request is invalid' do
        it 'returns status code 404 #1' do
          get "/applications/#{0}/chats/#{0}/messages/#{0}"
          expect(response).to have_http_status(404)
        end
        it 'returns status code 404 #2' do
          get "/applications/#{0}/chats/#{@chat[:chat_number]}"
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
      Message.delete_all
    end
  end
  describe "Post /chat/" do

    context 'when the request is valid' do
      before :all do
        @temp_chat_app = create :chat_app
        @chat = create :chat, app_token: @temp_chat_app[:token]
        post "/message/", params: {message: {chat_number: @chat[:chat_number],
                                             app_token: @temp_chat_app[:token],
                                             text: "text body"}}
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end
      it 'should update chat chats count' do
        chat = Chat.find(@chat[:id])
        expect(chat[:messages_count]).to eq(@chat[:messages_count] + 1)
      end
      it 'returns text name and number +1 after creation' do
        expect(json['text']).to eq("text body")
        expect(json['message_number']).to eq(1)
      end
      it 'returns text and number +2  after creating another message' do
        post "/message/", params: {message: {chat_number: @chat[:chat_number],
                                             app_token: @temp_chat_app[:token],
                                             text: "text body"}}
        expect(response).to have_http_status(201)
        expect(json['text']).to eq("text body")
        expect(json['message_number']).to eq(2)
      end
      it 'should not return the app id' do
        expect(json['id']).to eq(nil)
      end
      after :all do
        ChatApp.delete_all
        Chat.delete_all
      end
    end

    context 'when the request is invalid' do
      before {post "/message/", params: {message: {}}}
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
        post "/message/", params: {}
        expect(response.body).to match("Request Error")
        expect(response).to have_http_status(404)
      end
    end

  end
end
