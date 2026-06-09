require 'sus'
require_relative '../support/validate'

describe 'CommandResponse' do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "CommandResponse",
    "cId" => "O+14439=481WA001",
    "cTS" => "2015-06-08T08:05:06.584Z",
    "rvs" => [
      {
        "cCI" => "M0001",
        "n" => "status",
        "v" => "YellowFlash",
        "age" => "recent"
      }
    ]
  }}

  it 'accepts valid message' do
    expect( validate(message) ).to be_nil
  end

  it 'accepts multiple return values for one command' do
    message["rvs"] << {
      "cCI" => "M0001",
      "n" => "securityCode",
      "v" => "123",
      "age" => "recent"
    }
    expect( validate(message) ).to be_nil
  end

  it 'accepts all JSON value types' do
    [true, 1, 1.5, nil, ["a"], {"a" => "b"}].each do |value|
      message["rvs"].first["v"] = value
      expect( validate(message) ).to be_nil
    end
  end

  it 'catches missing component id' do
    message.delete 'cId'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["cId"]}]]
    )
  end

  it 'catches missing timestamp' do
    message.delete 'cTS'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["cTS"]}]]
    )
  end

  it 'catches bad timestamp' do
    message['cTS'] = "yesterday"
    expect( validate(message) ).to be == (
      [["/cTS", "pattern"]]
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

  it 'catches missing command code id' do
    message["rvs"].first.delete 'cCI'
    expect( validate(message) ).to be == (
      [["/rvs/0", "required", {"missing_keys"=>["cCI"]}]]
    )
  end

  it 'catches bad command code id' do
    message["rvs"].first['cCI'] = 3
    expect( validate(message) ).to be == (
      [["/rvs/0/cCI", "string"]]
    )

    message["rvs"].first['cCI'] = '3'
    expect( validate(message) ).to be == (
      [["/rvs/0/cCI", "pattern"]]
    )
  end

  it 'catches missing name' do
    message["rvs"].first.delete 'n'
    expect( validate(message) ).to be == (
      [["/rvs/0", "required", {"missing_keys"=>["n"]}]]
    )
  end

  it 'catches missing value' do
    message["rvs"].first.delete 'v'
    expect( validate(message) ).to be == (
      [["/rvs/0", "required", {"missing_keys"=>["v"]}]]
    )
  end

  it 'catches missing age' do
    message["rvs"].first.delete 'age'
    expect( validate(message) ).to be == (
      [["/rvs/0", "required", {"missing_keys"=>["age"]}]]
    )
  end

  it 'catches bad age' do
    message["rvs"].first['age'] = "bad"
    expect( validate(message) ).to be == (
      [["/rvs/0/age", "enum"]]
    )
  end
end
