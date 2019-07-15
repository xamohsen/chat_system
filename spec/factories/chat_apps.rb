FactoryBot.define do
  factory :chat_app do
    token {rand(1000000)}
    name {'application_chat'}
    chats_count {0}
  end
end