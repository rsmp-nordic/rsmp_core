require 'sus'
require_relative '../support/validate'

describe 'Alarm Request' do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "Alarm",
    "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
    "cId" => "AB+84001=860SG001",
    "aCId" => "A0001",
    "xACId" => "Serious lamp error",
    "aSp" => "Request"
  }}

  it 'accepts valid message' do
    expect( validate(message) ).to be_nil
  end

  it 'rejects lowercase aSp' do
    message["aSp"] = 'request'
    expect( validate(message) ).to be == (
      [["/aSp", "enum"]]
    )
  end

  it 'catches missing component id' do
    message.delete 'cId'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["cId"]}]]
    )
  end

  it 'catches missing alarm code id' do
    message.delete 'aCId'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["aCId"]}]]
    )
  end

  it 'catches bad alarm code id' do
    message['aCId'] = "001"
    expect( validate(message) ).to be == (
      [["/aCId", "pattern"]]
    )
  end

  it 'catches wrong alarm code id type' do
    message['aCId'] = 123
    expect( validate(message) ).to be == (
      [["/aCId", "string"]]
    )
  end

  it 'catches missing extended alarm code id' do
    message.delete 'xACId'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["xACId"]}]]
    )
  end

  it 'catches wrong extended alarm code id type' do
    message['xACId'] = 123
    expect( validate(message) ).to be == (
      [["/xACId", "string"]]
    )
  end
end
