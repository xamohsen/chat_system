FactoryBot.define do
  factory :message do
    number {rand(1000000)}
    text {"text message body"}
  end
end