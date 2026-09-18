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
    "step" => "Request",
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
      },
      {
        "name" => "traffic_light_controller/advanced",
        "version" => "1.3.4",
        "prefix" => "tlc/"
      },
      {
        "name" => "variable_message_sign",
        "version" => "1.0.6",
        "prefix" => "vms/"
      }
    ]
  }}

  let(:response) {{
    "mType" => "rSMsg",
    "mId" => "d2c4815f-8318-4f3d-938a-cb28529fd86f",
    "type" => "Version",
    "step" => "Response",
    "RSMP" => [
      { "vers" => "3.3.0" }
    ],
    "supervisorId" => "RN+SI0001",
    "SXLS" => [
      {
        "name" => "traffic_light_controller",
        "status" => "ok",
        "version" => "1.3.0"
      },
      {
        "name" => "traffic_light_controller/advanced",
        "status" => "unsupported"
      },
      {
        "name" => "variable_message_sign",
        "status" => "mismatch",
        "supported" => ["2.0.0", "2.0.1", "2.1.0"]
      },
      {
        "name" => "traffic_data",
        "status" => "expected"
      }
    ],
    "useAlarms" => false
  }}

  it 'catches missing request step when validating core 3.3.0' do
    request.delete 'step'
    expect( validate(request) ).not.to be_nil
  end

  it 'accepts valid request with step' do
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

  it 'accepts unknown siteId attributes in request' do
    request['siteId'] = [{ 'sId' => 'RN+SI0001', 'extra' => '123' }]
    expect( validate(request) ).to be_nil
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

  it 'accepts unknown RSMP item attributes' do
    request['RSMP'] = [{ 'vers' => '3.3.0', 'extra' => '123' }]
    expect( validate(request) ).to be_nil
  end

  it 'catches bad RSMP version format' do
    request['RSMP'].first['vers'] = 'latest'
    expect( validate(request) ).not.to be_nil
  end

  it 'accepts missing legacy SXL version in request' do
    request['RSMP'] = [{ 'vers' => '3.3.0' }]
    request.delete 'SXL'
    expect( validate(request) ).to be_nil
  end

  it 'catches bad legacy SXL version in request' do
    request['SXL'] = 'Release 1.0.1'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches missing SXLS in request' do
    request.delete 'SXLS'
    expect( validate(request) ).not.to be_nil
  end

  it 'accepts empty SXLS in request' do
    request['RSMP'] = [{ 'vers' => '3.3.0' }]
    request['SXLS'] = []
    request['SXL'] = ''
    expect( validate(request) ).to be_nil
  end

  it 'catches missing SXL when request SXLS is empty' do
    request['SXLS'] = []
    request.delete 'SXL'
    expect( validate(request) ).not.to be_nil
  end

  it 'catches nonempty SXL when request SXLS is empty' do
    request['SXLS'] = []
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

  it 'accepts empty SXLS in response' do
    response['SXLS'] = []
    expect( validate(response) ).to be_nil
  end

  it 'catches an unknown SXL status in response' do
    response['SXLS'].first['status'] = 'invalid'
    expect( validate(response) ).not.to be_nil
  end

  it 'catches bad useAlarms in response' do
    response['useAlarms'] = 'false'
    expect( validate(response) ).not.to be_nil
  end

  it 'accepts omitted useAlarms in response' do
    response.delete 'useAlarms'
    expect( validate(response) ).to be_nil
  end

  it 'accepts enabled useAlarms in response' do
    response['useAlarms'] = true
    expect( validate(response) ).to be_nil
  end

  it 'accepts unknown attributes in requests and responses' do
    [request, response].each do |message|
      message['futureOption'] = { 'enabled' => true }
      message['RSMP'].first['futureAttribute'] = 'value'
      message['SXLS'].each { |sxl| sxl['futureAttribute'] = 'value' }
      expect( validate(message) ).to be_nil
    end
  end

  it 'catches a response without SXLS' do
    response.delete 'SXLS'
    expect( validate(response) ).not.to be_nil
  end

  it 'catches a response SXL without a name' do
    response['SXLS'].first.delete 'name'
    expect( validate(response) ).not.to be_nil
  end

  it 'catches a response SXL without a status' do
    response['SXLS'].first.delete 'status'
    expect( validate(response) ).not.to be_nil
  end

  it 'catches numeric rejection codes without a status' do
    response['SXLS'] = [{ 'name' => 'traffic_light_controller', 'rejected' => 2 }]
    expect( validate(response) ).not.to be_nil
  end

  it 'catches an ok SXL without a version' do
    response['SXLS'].first.delete 'version'
    expect( validate(response) ).not.to be_nil
  end

  it 'catches a supported list for an ok SXL' do
    response['SXLS'].first['supported'] = ['1.3.0']
    expect( validate(response) ).not.to be_nil
  end

  it 'catches a mismatch SXL without supported versions' do
    response['SXLS'][2].delete 'supported'
    expect( validate(response) ).not.to be_nil
  end

  it 'catches a version for a mismatch SXL' do
    response['SXLS'][2]['version'] = '1.0.6'
    expect( validate(response) ).not.to be_nil
  end

  it 'catches a supported list that is not an array' do
    response['SXLS'][2]['supported'] = '2.0.0'
    expect( validate(response) ).not.to be_nil
  end

  it 'catches non-string supported versions' do
    response['SXLS'][2]['supported'] = [2]
    expect( validate(response) ).not.to be_nil
  end

  it 'catches malformed supported versions' do
    response['SXLS'][2]['supported'] = ['latest']
    expect( validate(response) ).not.to be_nil
  end

  %w[unsupported expected].each do |status|
    it "catches a version for an #{status} SXL" do
      response['SXLS'] = [{ 'name' => 'traffic_data', 'status' => status, 'version' => '1.0.0' }]
      expect( validate(response) ).not.to be_nil
    end

    it "catches supported versions for an #{status} SXL" do
      response['SXLS'] = [{ 'name' => 'traffic_data', 'status' => status, 'supported' => ['1.0.0'] }]
      expect( validate(response) ).not.to be_nil
    end
  end
end
