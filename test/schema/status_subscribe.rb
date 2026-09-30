require 'sus'
require_relative '../support/validate'

describe 'StatusSubscribe' do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusSubscribe",
    "cId" => "O+14439=481WA001",
    "sS" => [
      { "sCI" => "S0003", "n" => "inputstatus", "uRt" => "0", "sOc" => true }
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

  it 'catches missing uRt' do
    message['sS'].first.delete 'uRt'
    expect( validate(message) ).to be == (
      [["/sS/0", "required", {"missing_keys"=>["uRt"]}]]
    )
  end

  it 'catches bad uRt type' do
    message['sS'].first['uRt'] = 3
    expect( validate(message) ).to be == (
      [["/sS/0/uRt", "string"]]
    )

    message['sS'].first['uRt'] = "fast"
    expect( validate(message) ).to be == (
      [["/sS/0/uRt", "pattern"]]
    )
  end

  it 'catches sOc wrongly typed as string' do
    message['sS'].first['sOc'] = "True"
    expect( validate(message) ).to be == (
      [["/sS/0/sOc", "boolean"]]
    )
  end

  it 'catches missing sOc' do
    message['sS'].first.delete 'sOc'
    expect( validate(message) ).to be == (
      [["/sS/0", "required", {"missing_keys"=>["sOc"]}]]
    )
  end

  it 'catches extra attributes' do
    message['sS'].first['bad'] = "Foo"
    expect( validate(message) ).to be == (
      [["/sS/0/bad", "schema"]]
    )
  end
end
