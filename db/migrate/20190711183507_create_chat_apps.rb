class CreateChatApps < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_apps do |t|
      t.integer :token
      t.string :name
      t.timestamps
    end
  end
end
