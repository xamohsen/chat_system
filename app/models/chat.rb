class Chat < ApplicationRecord
  belongs_to :chat_app, :class_name => "ChatApp"
  has_many :messages, :class_name => "Message"
  validates_presence_of :number, :messages_count
end