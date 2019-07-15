require 'rails_helper'


def initialize_data
  @temp_chat_app = FactoryBot.create(:chat_app)
  100.times do
    FactoryBot.create :chat, chat_app_id: @temp_chat_app[:id]
  end
  @temp_chat_app
end

RSpec.describe ChatController, type: :request do
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

  after (:all) do
    Chat.delete_all
    ChatApp.delete_all
  end

end
