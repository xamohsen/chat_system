FactoryBot.define do
  factory :message do
    message_number {rand(1000000)}
    text {"text"}
  end
end