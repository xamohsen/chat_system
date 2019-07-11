class ChatApp < ApplicationRecord
  validates_presence_of :name, :token

  def self.find_chat_app (token)
    ChatApp.where(token: token).first()
  end
end
