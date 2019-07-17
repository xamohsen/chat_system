require 'rails_helper'


RSpec.describe Chat, type: :model do
  let!(:chat_app) {create :chat_app}

  subject {described_class.new(chat_number: 1, messages_count: 0, app_token: chat_app[:token])}
  it "should be valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "should not be valid without a number" do
    subject.chat_number = nil
    expect(subject).to_not be_valid
  end
  it "should not be valid without a messages_count" do
    subject.messages_count = nil
    expect(subject).to_not be_valid
  end
  it "should not be valid without a chat_app_id" do
    subject.app_token = nil
    expect(subject).to_not be_valid
  end
  it {should validate_presence_of(:chat_number)}
  it {should validate_presence_of(:messages_count)}
  describe "Associations" do
    it {should have_many(:messages)}
    it {should belong_to(:chat_app)}
  end
end
