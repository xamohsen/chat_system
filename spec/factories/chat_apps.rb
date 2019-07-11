FactoryBot.define do
  factory :chat_app do
    token {rand(1000000)}
    name {'application_chat'}
  end
end