class Message < ApplicationRecord
  belongs_to :chat
  validates_presence_of :number, :text, :chat_id
end
