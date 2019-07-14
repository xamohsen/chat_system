require 'rails_helper'


def initialize_test_data
  let!(:apps_number) {10}
  let!(:chat_apps) {create_list :chat_app, apps_number}
  let(:chat_app_token) {chat_apps.first.token}
end

RSpec.describe 'chat app api', type: :request do
  initialize_test_data

  describe 'GET /applications' do
    before {get '/applications'}
    it 'returns chat_apps' do
      expect(json).not_to be_empty
      expect(json.size).to eq(apps_number)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    it 'should not return the apps id' do
      json.each {|app| expect(app['id']).to eq(nil)}
    end
  end

  describe "GET /application/id" do
    before {get "/application/#{chat_app_token}"}
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    it 'returns chat_app by token' do
      expect(json['token']).to eq(chat_app_token)
    end
    it 'should not return the app id' do
      expect(json['id']).to eq(nil)
    end
  end

  describe "Post /application/" do

    context 'when the request is valid' do
      before {post "/application/", params: {app: {name: 'app#1'}}}
      it 'returns status code 200' do
        expect(response).to have_http_status(201)
      end
      it 'returns chat_app name and token +1 after creation' do
        expect(json['token']).to eq(apps_number + 1)
        expect(json['name']).to eq('app#1')
      end
      it 'returns chat_app name and token +2  after creating another app' do
        post "/application/", params: {app: {name: 'app#2'}}
        expect(json['token']).to eq(apps_number + 2)
        expect(json['name']).to eq('app#2')
      end
      it 'should not return the app id' do
        expect(json['id']).to eq(nil)
      end
    end

    context 'when the request is invalid' do
      before {post "/application/", params: {app: {}}}
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a validation failure message' do
        expect(response.body).to match("Name can't be blank")
      end
      it 'returns error request#1' do
        post "/application/"
        expect(response.body).to match("Validation failed: Name can't be blank, Token can't be blank")
        expect(response).to have_http_status(422)
      end
      it 'returns error request#2' do
        post "/application/", params: {}
        expect(response.body).to match("Validation failed: Name can't be blank, Token can't be blank")
        expect(response).to have_http_status(422)
      end
    end

  end
end
