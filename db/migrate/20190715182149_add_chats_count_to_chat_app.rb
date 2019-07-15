class AddChatsCountToChatApp < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_apps, :chats_count, :integer
  end
end
