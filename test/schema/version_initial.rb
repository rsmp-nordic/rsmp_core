require 'sus'
require_relative '../support/validate'

describe 'Initial Version validation' do
  let(:schema) { JSONSchemer.schema(Pathname.new(File.expand_path('../../schema/version_initial.json', __dir__))) }
  let(:message) {{
    'mType' => 'rSMsg',
    'type' => 'Version',
    'RSMP' => [{ 'vers' => '3.2.2' }, { 'vers' => '3.3.0' }]
  }}

  it 'accepts the shared fields without requiring the rest of a Version message' do
    expect(schema.valid?(message)).to be == true
    expect(validate(message)).not.to be_nil
  end

  it 'accepts earlier spellings and versions not implemented by the receiver' do
    ['3.2', '3.1.2', '3.3.0', '9.7.0'].each do |version|
      message['RSMP'] = [{ 'vers' => version }]
      expect(schema.valid?(message)).to be == true
    end
  end

  it 'leaves identity, step, SXL and identifier validation to the selected version' do
    message.merge!('mId' => nil, 'step' => 42, 'siteId' => false, 'SXL' => [], 'SXLS' => 'invalid')
    expect(schema.valid?(message)).to be == true
  end

  it 'allows unknown attributes in the message and version entries' do
    message['futureField'] = { 'anything' => true }
    message['RSMP'].first['futureField'] = 42
    expect(schema.valid?(message)).to be == true
  end

  it 'rejects invalid envelopes and missing preliminary fields' do
    [nil, [], 'Version', 1].each do |value|
      expect(schema.valid?(value)).to be == false
    end
    ['mType', 'type', 'RSMP'].each do |field|
      expect(schema.valid?(message.reject { |key, _| key == field })).to be == false
    end
    expect(schema.valid?(message.merge('mType' => 'other'))).to be == false
    expect(schema.valid?(message.merge('type' => 'Watchdog'))).to be == false
  end

  it 'rejects malformed version offers before selection' do
    [nil, {}, [], ['3.3.0'], [{}], [{ 'vers' => 3.3 }]].each do |versions|
      message['RSMP'] = versions
      expect(schema.valid?(message)).to be == false
    end
    ['', '3', '3.3.0junk', '3.3.0.1', "3.3.0\n", ' 3.3.0'].each do |version|
      message['RSMP'] = [{ 'vers' => version }]
      expect(schema.valid?(message)).to be == false
    end
  end

  it 'still rejects invalid mId during full validation after preliminary validation succeeds' do
    message.merge!('step' => 'Request', 'siteId' => [{ 'sId' => 'TLC001' }], 'SXL' => '', 'SXLS' => [])
    message['mId'] = 'a28e94b9-05c7-41bb-8f8b-54693adc9698'
    expect(validate(message)).to be_nil
    message['mId'] = 'invalid'
    expect(schema.valid?(message)).to be == true
    expect(validate(message)).not.to be_nil
  end
end
