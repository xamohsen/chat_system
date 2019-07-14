class ChatApp < ApplicationRecord
  has_many :chats, :class_name => "Chat", :foreign_key => "chat_app_id",dependent: :destroy

  validates_presence_of :name, :token

  def self.find_chat_app (token)
    ChatApp.where(token: token).first
  end
end
