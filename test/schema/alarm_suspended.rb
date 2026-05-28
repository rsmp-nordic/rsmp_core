require 'sus'
require_relative '../support/validate'

describe 'Alarm Suspended' do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "Alarm",
    "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
    "cId" => "AB+84001=860SG001",
    "aCId" => "A0001",
    "xACId" => "",
    "aSp" => "Suspend",
    "ack" => "notAcknowledged",
    "aS" => "Active",
    "sS" => "Suspended",
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

end
