require 'sus'
require_relative '../support/validate'

describe 'MessageNotAck' do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "siteId" => [
      { "sId" => "RN+SI0001" }
    ],
    "type" => "MessageNotAck",
    "oMId" => "92b9706d-0466-4518-8663-00b9690e9c41",
    "rea" => "Unknown json type: Watchdog"
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

  it 'catches bad oMId format' do
    message['oMId'] = '4173c2c8-a933-ouch-9425-66d4613731ed'
    expect( validate(message) ).to be == (
      [["/oMId", "pattern"]]
    )
  end

  it 'catches wrong oMId type' do
    message['oMId'] = 1234
    expect( validate(message) ).to be == (
      [["/oMId", "string"]]
    )
  end

  it 'allows reason to be omitted' do
    message.delete 'rea'
    expect( validate(message) ).to be_nil
  end

  it 'catches bad reason, must be string' do
    message['rea'] = 123
    expect( validate(message) ).to be == (
      [["/rea", "string"]]
    )
  end
end
