FactoryBot.define do
  factory :chat do
    number {rand(1000000)}
    messages_count {0}
  end
end