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

  %w[0 1 0.0 0.001 0.5 2.5].each do |interval|
    it "accepts update interval #{interval.inspect}" do
      message['sS'].first['uRt'] = interval
      expect( validate(message) ).to be_nil
    end
  end

  ['NaN', 'Infinity', '0.5s', '0,5', '', 0.5, nil].each do |interval|
    it "rejects update interval #{interval.inspect}" do
      message['sS'].first['uRt'] = interval
      expect( validate(message) ).not.to be_nil
    end
  end

  it 'rejects negative intervals regardless of sendOnChange' do
    %w[-1 -0.5].each do |interval|
      [true, false].each do |on_change|
        message['sS'].first.merge!('uRt' => interval, 'sOc' => on_change)
        expect( validate(message) ).not.to be_nil
      end
    end
  end

  it 'requires sendOnChange for zero intervals but not positive intervals' do
    message['sS'].first['sOc'] = false
    %w[0 0.0 0.00].each do |interval|
      message['sS'].first['uRt'] = interval
      expect( validate(message) ).not.to be_nil
    end
    %w[1 0.5].each do |interval|
      message['sS'].first['uRt'] = interval
      expect( validate(message) ).to be_nil
    end
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
    expect( validate(message).include?(["/sS/0/uRt", "string"]) ).to be == true

    message['sS'].first['uRt'] = "fast"
    expect( validate(message) ).to be == (
      [["/sS/0/uRt", "pattern"]]
    )
  end

  it 'catches sOc wrongly typed as string' do
    message['sS'].first['sOc'] = "True"
    expect( validate(message).include?(["/sS/0/sOc", "boolean"]) ).to be == true
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
