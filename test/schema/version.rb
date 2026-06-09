require 'sus'
require_relative '../support/validate'

describe 'Version' do
  let(:request) {{
    "mType" => "rSMsg",
    "mId" => "a28e94b9-05c7-41bb-8f8b-54693adc9698",
    "siteId" => [
      { "sId" => "RN+SI0001" }
    ],
    "type" => "Version",
    "RSMP" => [
      { "vers" => "3.2.2" },
      { "vers" => "3.3.0" }
    ],
    "SXL" => "1.3.0",
    "SXLS" => [
      {
        "name" => "traffic_light_controller",
        "version" => "1.3.0",
        "prefix" => "tlc/"
      }
    ]
  }}

  let(:response) {{
    "mType" => "rSMsg",
    "mId" => "a28e94b9-05c7-41bb-8f8b-54693adc9698",
    "type" => "Version",
    "step" => "Response",
    "RSMP" => [
      { "vers" => "3.3.0" }
    ],
    "supervisorId" => "RN+SI0001",
    "SXLS" => [
      {
        "name" => "traffic_light_controller",
        "version" => "1.3.0"
      },
      {
        "name" => "variable_message_sign",
        "rejected" => 2,
        "reason" => "Supervisor only supports 2.0.0"
      }
    ],
    "receiveAlarms" => false
  }}

  it 'accepts valid request without step for backward compatibility' do
    expect( validate(request) ).to be_nil
  end

  it 'accepts valid request with step' do
    request["step"] = "Request"
    expect( validate(request) ).to be_nil
  end

  it 'accepts valid response' do
    expect( validate(response) ).to be_nil
  end

  it 'catches missing mId' do
    request.delete 'mId'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches missing siteId in request' do
    request.delete 'siteId'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches multiple site ids in request' do
    request['siteId'] << { "sId" => "RN+SI0002" }
    expect( validate(request) ).not.to be_nil
  end

  it 'catches bad siteId format in request' do
    request['siteId'] = '1.0'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches bad siteId item in request' do
    request['siteId'] = [{}]
    expect( validate(request) ).not.to be_nil
  end

  it 'catches extra siteId attributes in request' do
    request['siteId'] = [{ 'sId' => 'RN+SI0001', 'extra' => '123' }]
    expect( validate(request) ).not.to be_nil
  end

  it 'catches missing RSMP version' do
    request.delete 'RSMP'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches bad RSMP format' do
    request['RSMP'] = '1.0'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches empty RSMP array' do
    request['RSMP'] = []
    expect( validate(request) ).not.to be_nil
  end

  it 'catches bad RSMP item' do
    request['RSMP'] = ['1.0']
    expect( validate(request) ).not.to be_nil
  end

  it 'catches missing RSMP item version' do
    request['RSMP'] = [{}]
    expect( validate(request) ).not.to be_nil
  end

  it 'catches extra RSMP item attributes' do
    request['RSMP'] = [{ 'vers' => '3.3.0', 'extra' => '123' }]
    expect( validate(request) ).not.to be_nil
  end

  it 'catches bad RSMP version format' do
    request['RSMP'].first['vers'] = 'latest'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches missing legacy SXL version in request' do
    request.delete 'SXL'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches bad legacy SXL version in request' do
    request['SXL'] = 'Release 1.0.1'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches missing SXLS in request' do
    request.delete 'SXLS'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches malformed SXLS item in request' do
    request['SXLS'] = [{ 'name' => 'traffic_light_controller' }]
    expect( validate(request) ).not.to be_nil
  end

  it 'catches bad request step' do
    request['step'] = 'Bad'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches missing step in response' do
    response.delete 'step'
    expect( validate(response) ).not.to be_nil
  end

  it 'catches response with multiple RSMP versions' do
    response['RSMP'] << { 'vers' => '3.2.2' }
    expect( validate(response) ).not.to be_nil
  end

  it 'catches bad rejection code in response' do
    response['SXLS'].last['rejected'] = 4
    expect( validate(response) ).not.to be_nil
  end

  it 'catches bad receiveAlarms in response' do
    response['receiveAlarms'] = 'false'
    expect( validate(response) ).not.to be_nil
  end
end
