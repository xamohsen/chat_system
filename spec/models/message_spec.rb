require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:chat_app) {create :chat_app}
  let!(:chat) {create :chat, chat_app_id: chat_app[:id]}

  subject {described_class.new(number: 1, text: "text text #1",chat_id: chat[:id], chat_app_id: chat_app[:id])}
  it "should be valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "should not be valid without a number" do
    subject.number = nil
    expect(subject).to_not be_valid
  end
  it "should not be valid without a text" do
    subject.text = nil
    expect(subject).to_not be_valid
  end
  it "should not be valid without a chat_id" do
    subject.chat_id = nil
    expect(subject).to_not be_valid
  end
  it {should validate_presence_of(:number)}
  it {should validate_presence_of(:text)}
  it {should validate_presence_of(:chat_id)}
  describe "Associations" do
    it {should belong_to(:chat)}
  end
end
