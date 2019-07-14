class Chat < ApplicationRecord
  belongs_to :chat_app, :class_name => "ChatApp"
  validates_presence_of :number, :messages_count
end