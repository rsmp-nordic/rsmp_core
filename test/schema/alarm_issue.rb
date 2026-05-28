require 'sus'
require_relative '../support/validate'

describe 'Alarm Issue' do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "Alarm",
    "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
    "cId" => "AB+84001=860SG001",
    "aCId" => "A0001",
    "xACId" => "Serious lamp error",
    "aSp" => "Issue",
    "ack" => "notAcknowledged",
    "aS" => "Active",
    "sS" => "notSuspended",
    "aTs" => "2009-10-01T11:59:31.571Z",
    "cat" => "D",
    "pri" => "2",
    "rvs" => [
      { "n" => "color", "v" => "red" }
    ]
  }}

  it 'accepts valid message' do
    expect( validate(message) ).to be_nil
  end

  it 'rejects lowercase aSp' do
    message["aSp"] = 'issue'
    expect( validate(message) ).to be == (
      [["/aSp", "enum"]]
    )
  end

  it 'rejects lowercase aS variants' do
    ["active", "inactive", "InActive"].each do |status|
      message["aS"] = status
      expect( validate(message) ).to be == (
        [["/aS", "enum"]]
      )
    end
  end

  it 'rejects mixed-case ack' do
    message["ack"] = 'NotAcknowledged'
    expect( validate(message) ).to be == (
      [["/ack", "enum"]]
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

  it 'catches missing aSp' do
    message.delete 'aSp'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["aSp"]}]]
    )
  end

  it 'catches bad aSp' do
    message['aSp'] = "Bad"
    expect( validate(message) ).to be == (
      [["/aSp", "enum"]]
    )
  end

  it 'catches wrong aSp type' do
    message['aSp'] = 123
    expect( validate(message) ).to be == (
      [["/aSp", "string"],
       ["/aSp", "enum"]]
    )
  end

  it 'catches missing aS' do
    message.delete 'aS'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["aS"]}]]
    )
  end

  it 'catches bad aS' do
    message['aS'] = "Bad"
    expect( validate(message) ).to be == (
      [["/aS", "enum"]]
    )
  end

  it 'catches wrong aS type' do
    message['aS'] = 123
    expect( validate(message) ).to be == (
      [["/aS", "string"],
       ["/aS", "enum"]]
    )
  end

  it 'catches missing sS' do
    message.delete 'sS'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["sS"]}]]
    )
  end

  it 'catches bad sS' do
    message['sS'] = "Bad"
    expect( validate(message) ).to be == (
      [["/sS", "enum"]]
    )
  end

  it 'catches wrong sS type' do
    message['sS'] = 123
    expect( validate(message) ).to be == (
      [["/sS", "string"],
       ["/sS", "enum"]]
    )
  end

  it 'catches missing ack' do
    message.delete 'ack'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["ack"]}]]
    )
  end

  it 'catches bad ack' do
    message['ack'] = "Bad"
    expect( validate(message) ).to be == (
      [["/ack", "enum"]]
    )
  end

  it 'catches wrong ack type' do
    message['ack'] = 123
    expect( validate(message) ).to be == (
      [["/ack", "string"],
       ["/ack", "enum"]]
    )
  end

  it 'catches missing category' do
    message.delete 'cat'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["cat"]}]]
    )
  end

  it 'catches bad category' do
    message['cat'] = "A"
    expect( validate(message) ).to be == (
      [["/cat", "enum"]]
    )
  end

  it 'catches wrong category type' do
    message['cat'] = 123
    expect( validate(message) ).to be == (
      [["/cat", "string"],
       ["/cat", "enum"]]
    )
  end

  it 'catches missing priority' do
    message.delete 'pri'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["pri"]}]]
    )
  end

  it 'catches bad priority' do
    message['pri'] = "4"
    expect( validate(message) ).to be == (
      [["/pri", "enum"]]
    )
  end

  it 'catches wrong priority type' do
    message['pri'] = 1
    expect( validate(message) ).to be == (
      [["/pri", "string"],
       ["/pri", "enum"]]
    )
  end

  it 'catches missing timestamp' do
    message.delete 'aTs'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["aTs"]}]]
    )
  end

  it 'catches bad timestamp' do
    message['aTs'] = "yesterday"
    expect( validate(message) ).to be == (
      [["/aTs", "pattern"]]
    )
  end

  it 'catches wrong timestamp type' do
    message['aTs'] = 123
    expect( validate(message) ).to be == (
      [["/aTs", "string"]]
    )
  end

  it 'catches missing rvs' do
    message.delete 'rvs'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["rvs"]}]]
    )
  end

  it 'catches bad rvs type' do
    message["rvs"] = {}
    expect( validate(message) ).to be == (
      [["/rvs", "array"]]
    )
  end

  it 'catches missing alarm return value name' do
    message["rvs"].first.delete 'n'
    expect( validate(message) ).to be == (
      [["/rvs/0", "required", {"missing_keys"=>["n"]}]]
    )
  end

  it 'catches bad alarm return value name' do
    message["rvs"].first['n'] = 3
    expect( validate(message) ).to be == (
      [["/rvs/0/n", "string"]]
    )
  end

  it 'catches missing alarm return value' do
    message["rvs"].first.delete 'v'
    expect( validate(message) ).to be == (
      [["/rvs/0", "required", {"missing_keys"=>["v"]}]]
    )
  end

  it 'catches bad alarm return value' do
    message["rvs"].first['v'] = 3
    expect( validate(message) ).to be == (
      [["/rvs/0/v", "string"]]
    )
  end
end
