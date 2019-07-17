FactoryBot.define do
  factory :chat do
    chat_number {rand(1000000)}
    messages_count {0}
  end
end