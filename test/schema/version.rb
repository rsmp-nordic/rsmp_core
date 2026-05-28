require 'sus'
require_relative '../support/validate'

describe 'Version' do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "a28e94b9-05c7-41bb-8f8b-54693adc9698",
    "siteId" => [
      { "sId" => "RN+SI0001" }
    ],
    "type" => "Version",
    "RSMP" => [
      { "vers" => "3.2.0" },
      { "vers" => "3.2.1" },
      { "vers" => "3.2.2" }
    ],
    "SXL" => "1.2.1"
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

  it 'catches missing siteId' do
    message.delete 'siteId'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["siteId"]}]]
    )
  end

  it 'catches bad siteId format, must be array' do
    message['siteId'] = '1.0'
    expect( validate(message) ).to be == (
      [["/siteId", "array"]]
    )
  end

  it 'catches bad siteId format, array cannot be empty' do
    message['siteId'] = []
    expect( validate(message) ).to be == (
      [["/siteId", "minItems"]]
    )
  end

  it 'catches bad siteId format, item must be hash' do
    message['siteId'] = ['1.0']
    expect( validate(message) ).to be == (
      [["/siteId/0", "object"]]
    )
  end

  it 'catches bad siteId format, item must have version' do
    message['siteId'] = [{}]
    expect( validate(message) ).to be == (
      [["/siteId/0", "required", {"missing_keys"=>["sId"]}]]
    )
  end

  it 'catches bad siteId format, item cannot have extra attributes' do
    message['siteId'] = [{'sId'=>'RN+SI0001','extra'=>'123'}]
    expect( validate(message) ).to be == (
      [["/siteId/0/extra", "schema"]]
    )
  end

  it 'catches missing RSMP version' do
    message.delete 'RSMP'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["RSMP"]}]]
    )
  end

  it 'catches bad RSMP format, must be array' do
    message['RSMP'] = '1.0'
    expect( validate(message) ).to be == (
      [["/RSMP", "array"]]
    )
  end

  it 'catches bad RSMP format, array cannot be empty' do
    message['RSMP'] = []
    expect( validate(message) ).to be == (
      [["/RSMP", "minItems"]]
    )
  end

  it 'catches bad RSMP format, item must be hash' do
    message['RSMP'] = ['1.0']
    expect( validate(message) ).to be == (
      [["/RSMP/0", "object"]]
    )
  end

  it 'catches bad RSMP format, item must have version' do
    message['RSMP'] = [{}]
    expect( validate(message) ).to be == (
      [["/RSMP/0", "required", {"missing_keys"=>["vers"]}]]
    )
  end

  it 'catches bad RSMP format, item cannot have extra attributes' do
    message['RSMP'] = [{'vers'=>'1.0.0','extra'=>'123'}]
    expect( validate(message) ).to be == (
      [["/RSMP/0/extra", "schema"]]
    )
  end

  it 'catches bad RSMP format, version must be 1.0.0 format' do
    message['RSMP'].first['vers'] = 'latest'
    expect( validate(message) ).to be == (
      [["/RSMP/0/vers", "pattern"]]
    )
  end

  it 'catches missing SXL version' do
    message.delete 'SXL'
    expect( validate(message) ).to be == (
      [["", "required", {"missing_keys"=>["SXL"]}]]
    )
  end

  it 'catches bad SXL version' do
    message['SXL'] = 'Release 1.0.1'
    expect( validate(message) ).to be == (
      [["/SXL", "pattern"]]
    )
  end
end
