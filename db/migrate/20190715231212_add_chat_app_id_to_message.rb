class AddChatAppIdToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :chat_app_id, :integer
  end
end
