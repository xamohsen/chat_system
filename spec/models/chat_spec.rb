require 'rails_helper'


RSpec.describe Chat, type: :model do
  let!(:chat_app) {create :chat_app}

  subject {described_class.new(number: '1', messages_count: 0, chat_app_id: chat_app[:id])}
  it "should be valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "should not be valid without a number" do
    subject.number = nil
    expect(subject).to_not be_valid
  end
  it "should not be valid without a messages_count" do
    subject.messages_count = nil
    expect(subject).to_not be_valid
  end
  it "should not be valid without a chat_app_id" do
    subject.chat_app_id = nil
    expect(subject).to_not be_valid
  end
  it {should validate_presence_of(:number)}
  it {should validate_presence_of(:messages_count)}
  describe "Associations" do
    it {should have_many(:messages)}
    it {should belong_to(:chat_app)}
  end
end
