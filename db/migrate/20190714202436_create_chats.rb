class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :messages_count
      t.integer :number

      t.timestamps
    end
  end
end
