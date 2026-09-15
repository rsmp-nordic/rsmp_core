require 'sus'
require_relative '../support/validate'

describe 'MessageAck' do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "MessageAck",
    "oMId" => "49c6c824-a933-47e3-b9ff-15aa8b5bbeef"
  }}

  it 'accepts valid message' do
    expect( validate(message) ).to be_nil
  end

  it 'catches missing oMId' do
    message.delete 'oMId'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["oMId"]}]]
    )
  end

  it 'catches bad oMId' do
    message['oMId'] = '4173c2c8a93343cb942566d4613731ed'  # missing dashes
    expect( validate(message) ).to be == (
      [["/oMId", "pattern"]]
    )
  end
end
