require 'sus'
require_relative '../support/validate'

describe 'Identifier paths in messages' do
  let(:envelope) {{
    'mType' => 'rSMsg',
    'mId' => 'a1b2c3d4-e5f6-47a8-89b0-a1b2c3d4e5f6'
  }}

  let(:component_list) { envelope.merge(
    'type' => 'ComponentList',
    'components' => [{ 'id' => 'KK+AG0503=001SG001', 'type' => 'tlc/sg' }]
  ) }

  let(:version) { envelope.merge(
    'type' => 'Version', 'step' => 'Request',
    'siteId' => [{ 'sId' => 'RN+SI0001' }],
    'RSMP' => [{ 'vers' => '3.3.0' }],
    'SXLS' => [{ 'name' => 'nordic/tlc', 'version' => '1.0.0', 'prefix' => 'nordic/tlc/' }]
  ) }

  let(:code_messages) { [
    envelope.merge('type' => 'CommandRequest', 'cId' => 'tc',
      'arg' => [{ 'cCI' => 'M0001', 'n' => 'plan', 'cO' => 'setValue', 'v' => 1 }]),
    envelope.merge('type' => 'StatusRequest', 'cId' => 'tc',
      'sS' => [{ 'sCI' => 'S0001', 'n' => 'plan' }]),
    envelope.merge('type' => 'Alarm', 'cId' => 'tc',
      'aCId' => 'A0001', 'aSp' => 'Request', 'xACId' => '')
  ] }

  it 'accepts component paths and legacy Nordic IDs' do
    ['dl/radar/1', 'KK+AG0503=001SG001', 'intersection/1/SG_2-a'].each do |id|
      component_list['components'].first['id'] = id
      expect(validate(component_list)).to be_nil
    end
  end

  it 'rejects malformed component IDs and selectors as inventory IDs' do
    ['', '/', '/dl/1', 'dl/1/', 'dl//1', 'dl/1 2', "dl/\u00e5", nil].each do |id|
      component_list['components'].first['id'] = id
      expect(validate(component_list)).not.to be_nil
    end
  end

  it 'accepts component type paths' do
    ['tlc/sg', 'nordic/tlc/SG_1-a', 'tc'].each do |type|
      component_list['components'].first['type'] = type
      expect(validate(component_list)).to be_nil
    end
  end

  it 'rejects malformed component types' do
    ['', '/tlc/sg', 'tlc/sg/', 'tlc//sg', 'tlc/sg+1', 'tlc/sg=1', "tlc/sg\n"].each do |type|
      component_list['components'].first['type'] = type
      expect(validate(component_list)).not.to be_nil
    end
  end

  it 'accepts lowercase SXL paths and hierarchical prefixes' do
    expect(validate(version)).to be_nil
    version['SXLS'].first.merge!('name' => 'tlc', 'prefix' => 'TLC_1-a/')
    expect(validate(version)).to be_nil
  end

  it 'rejects malformed or uppercase SXL names in requests and responses' do
    response = envelope.merge('type' => 'Version', 'step' => 'Response',
      'RSMP' => [{ 'vers' => '3.3.0' }], 'supervisorId' => 'supervisor',
      'SXLS' => [{ 'name' => 'nordic/tlc', 'status' => 'ok', 'version' => '1.0.0' }])
    [version, response].each do |message|
      ['', '/nordic/tlc', 'nordic/tlc/', 'nordic//tlc', 'Nordic/tlc', 'nordic/tlc+1', "tlc\n"].each do |name|
        message['SXLS'].first['name'] = name
        expect(validate(message)).not.to be_nil
      end
    end
  end

  it 'requires exactly one trailing slash and nonempty prefix segments' do
    ['', '/', '/tlc/', 'nordic//tlc/', 'nordic/tlc', 'tlc//', 'tlc+1/', "tlc/\n"].each do |prefix|
      version['SXLS'].first['prefix'] = prefix
      expect(validate(version)).not.to be_nil
    end
  end

  it 'accepts legacy and path codes for all three message categories' do
    code_messages.each_with_index do |message, index|
      target, key = [[message.dig('arg', 0), 'cCI'], [message.dig('sS', 0), 'sCI'], [message, 'aCId']][index]
      expect(validate(message)).to be_nil
      ['tlc/plan/set', 'plan/current', 'deadlock', '3', 'TLC/Plan_1-a'].each do |code|
        target[key] = code
        expect(validate(message)).to be_nil
      end
    end
  end

  it 'rejects malformed code paths for all three message categories' do
    code_messages.each_with_index do |message, index|
      target, key = [[message.dig('arg', 0), 'cCI'], [message.dig('sS', 0), 'sCI'], [message, 'aCId']][index]
      ['', '/tlc/plan', 'tlc/plan/', 'tlc//plan', 'tlc/plan set', 'M+1', 'S=1', "A0001\n", nil, 3].each do |code|
        target[key] = code
        expect(validate(message)).not.to be_nil
      end
    end
  end
end
