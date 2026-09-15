require 'sus'
require_relative '../support/validate'

describe 'Core message fields' do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "CommandRequest",
    "siteId" => [
      { "sId" => "RN+SI0001" }
    ],
    "cId" => "O+14439=481WA001",
    "arg" => [
      {
        "cCI" => "M0001",
        "n" => "status",
        "cO" => "setValue",
        "v" => "YellowFlash"
      }
    ]
  }}

  it 'accepts valid message' do
    expect( validate(message) ).to be_nil
  end

  it 'accepts ComponentList message type' do
    message.replace(
      "mType" => "rSMsg",
      "type" => "ComponentList",
      "mId" => "a1b2c3d4-e5f6-47a8-89b0-a1b2c3d4e5f6",
      "components" => [
        {
          "id" => "groups/1",
          "type" => "tlc/sg",
          "name" => "Signal Group 1"
        }
      ]
    )
    expect( validate(message) ).to be_nil
  end

  it 'catches missing mType' do
    message.delete 'mType'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["mType"]}]]
    )
  end

  it 'catches missing mId' do
    message.delete 'mId'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["mId"]}]]
    )
  end

  it 'catches missing type' do
    message.delete 'type'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["type"]}]]
    )
  end

  it 'catches bad mType' do
    message['mType'] = 'ohno'
    expect( validate(message) ).to be == (
      [["/mType", "const"]]
    )
  end

  it 'catches bad mId' do
    message['mId'] = '4173c2c8a93343cb942566d4613731ed'  # missing dashes
    expect( validate(message) ).to be == (
      [["/mId", "pattern"]]
    )
  end

  it 'catches bad type' do
    message['type'] = 'MyMessage'
    expect( validate(message) ).to be == (
      [["/type", "enum"]]
    )
  end
end
