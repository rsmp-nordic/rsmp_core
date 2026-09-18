require 'sus'
require_relative '../support/validate'

describe 'AggregatedStatus' do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "AggregatedStatus",
    "mId" => "be12ab9a-800c-4c19-8c50-adf832f22420",
    "aSTS" => "2015-06-08T08:05:06.584Z",
    "se" => [true, false, false, false, false, false, false, false]
  }}

  it 'accepts valid message' do
    expect( validate(message) ).to be_nil
  end

  %w[cId fP fS].each do |attribute|
    it "catches removed #{attribute} in a core 3.3.0 message" do
      message[attribute] = ''
      expect( validate(message) ).not.to be_nil
    end
  end

  it 'catches missing mId' do
    message.delete 'mId'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["mId"]}]]
    )
  end

  it 'catches missing aSTS' do
    message.delete 'aSTS'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["aSTS"]}]]
    )
  end

  it 'catches bad aSTS' do
    message['aSTS'] = "2015-06-08T08:05:06.5843Z"
    expect( validate(message) ).to be == (
      [["/aSTS", "pattern"]]
    )
  end

  it 'catches missing se' do
    message.delete 'se'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["se"]}]]
    )
  end

  it 'catches bad se type' do
    message['se'] = 123
    expect( validate(message) ).to be == (
      [["/se", "array"]]
    )
  end

  it 'catches se too short' do
    message['se'] = [true, false, false, false, false, false, false]
    expect( validate(message) ).to be == (
      [["/se", "minItems"]]
    )
  end

  it 'catches se too long' do
    message['se'] = [true, false, false, false, false, false, false, true, true]
    expect( validate(message) ).to be == (
      [["/se", "maxItems"]]
    )
  end

  it 'catches bad se item types' do
    message['se'] = [false, false, false, 1, nil, "", false, false]
    expect( validate(message) ).to be == (
      [["/se/3", "boolean"],
       ["/se/4", "boolean"],
       ["/se/5", "boolean"]]
    )
  end
end
