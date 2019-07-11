require 'rails_helper'

RSpec.describe ChatApp , type: :model do
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:token)}
end
