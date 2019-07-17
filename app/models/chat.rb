class Chat < ApplicationRecord
  belongs_to :chat_app, :class_name => "ChatApp", :primary_key => "token", :foreign_key => "app_token"
  has_many :messages, :class_name => "Message", :foreign_key => "chat_number"
  validates_presence_of :chat_number, :messages_count
end