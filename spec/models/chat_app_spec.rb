require 'rails_helper'

RSpec.describe ChatApp, type: :model do
  subject {described_class.new(name: 'app#1', token: 1)}
  it "should be valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "should not be valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end
  it "should not be valid without a token" do
    subject.token = nil
    expect(subject).to_not be_valid
  end
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:token)}
  describe "Associations" do
    it {should have_many(:chats)}
  end
end
