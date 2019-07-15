class LinkChatToChatApp < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :chat_app_id, :integer
  end
end
