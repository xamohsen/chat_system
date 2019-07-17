require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:chat_app) {create :chat_app}
  let!(:chat) {create :chat, app_token: chat_app[:token]}

  subject {described_class.new(message_number: 1,
                               text: "text text #1",
                               chat_number: chat[:chat_number],
                               app_token: chat_app[:token])}
  it "should be valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "should not be valid without a chat number" do
    subject.chat_number = nil
    expect(subject).to_not be_valid
  end
  it "should not be valid without a text" do
    subject.text = nil
    expect(subject).to_not be_valid
  end
  it "should not be valid without a message number" do
    subject.message_number = nil
    expect(subject).to_not be_valid
  end
  it {should validate_presence_of(:text)}
  it {should validate_presence_of(:chat_number)}
  it {should validate_presence_of(:app_token)}

  describe "Associations" do
    it {should belong_to(:chat)}
  end
end
