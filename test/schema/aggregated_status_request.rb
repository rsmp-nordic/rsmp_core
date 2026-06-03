require 'sus'
require_relative '../support/validate'

describe 'AggregatedStatusRequest' do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "AggregatedStatusRequest",
    "mId" => "be12ab9a-800c-4c19-8c50-adf832f22420",
    "cId" => "O+14439=481WA001"
  }}

  it 'accepts valid message' do
    expect( validate(message) ).to be_nil
  end

  it 'catches missing mId' do
    message.delete 'mId'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["mId"]}]]
    )
  end
end
