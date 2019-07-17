class AddIndexToChatApp < ActiveRecord::Migration[5.2]
  def change
    add_index :chat_apps, :token, :unique => true

    add_index :chats, :chat_number
    add_index :chats, :app_token

    add_index :messages, :app_token
    add_index :messages, :chat_number
    add_index :messages, :message_number

  end
end
