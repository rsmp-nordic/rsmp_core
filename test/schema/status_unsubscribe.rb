require 'sus'
require_relative '../support/validate'

describe 'StatusUnsubscribe' do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusUnsubscribe",
    "cId" => "O+14439=481WA001",
    "sS" => [
      { "sCI" => "S0003", "n" => "inputstatus" }
    ]
  }}

  it 'accepts valid message' do
    expect( validate(message) ).to be_nil
  end

  it 'catches missing component id' do
    message.delete 'cId'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["cId"]}]]
    )
  end

  it 'catches bad status code' do
    message['sS'].first['sCI'] = '99'
    expect( validate(message) ).to be == (
      [["/sS/0/sCI", "pattern"]]
    )
  end

  it 'catches missing sS' do
    message.delete 'sS'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["sS"]}]]
    )
  end

  it 'catches empty sS array' do
    message['sS'].clear
    expect( validate(message) ).to be == (
      [["/sS", "minItems"]]
    )
  end

  it 'catches bad sS type' do
    message['sS'] = {}
    expect( validate(message) ).to be == (
      [["/sS", "array"]]
    )
  end

  it 'catches missing status code id' do
    message['sS'].first.delete 'sCI'
    expect( validate(message) ).to be == (
      [["/sS/0", "required", {"missing_keys"=>["sCI"]}]]
    )
  end

  it 'catches bad status code id' do
    message['sS'].first['sCI'] = 3
    expect( validate(message) ).to be == (
      [["/sS/0/sCI", "string"]]
    )

    message['sS'].first['sCI'] = '3'
    expect( validate(message) ).to be == (
      [["/sS/0/sCI", "pattern"]]
    )
  end

  it 'catches missing name' do
    message['sS'].first.delete 'n'
    expect( validate(message) ).to be == (
      [["/sS/0", "required", {"missing_keys"=>["n"]}]]
    )
  end

  it 'catches bad name type' do
    message['sS'].first['n'] = 3
    expect( validate(message) ).to be == (
      [["/sS/0/n", "string"]]
    )
  end

  it 'catches extra attributes' do
    message['sS'].first['bad'] = "Foo"
    expect( validate(message) ).to be == (
      [["/sS/0/bad", "schema"]]
    )
  end
end
