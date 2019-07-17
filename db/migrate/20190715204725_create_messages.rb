class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :text
      t.integer :message_number
      t.integer :app_token
      t.integer :chat_number
      t.timestamps
    end
  end
end
