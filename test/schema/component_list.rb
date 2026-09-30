require 'sus'
require_relative '../support/validate'

describe 'ComponentList' do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "ComponentList",
    "mId" => "a1b2c3d4-e5f6-47a8-89b0-a1b2c3d4e5f6",
    "components" => [
      {
        "id" => "detectors/radar/1",
        "type" => "tlc/dl",
        "name" => "Bus Detection A1 Northbound"
      },
      {
        "id" => "groups/2",
        "type" => "tlc/sg",
        "name" => "Signal Group A1 North"
      }
    ]
  }}

  it 'accepts valid message' do
    expect( validate(message) ).to be_nil
  end

  it 'catches missing mId' do
    message.delete 'mId'
    expect( validate(message) ).not.to be_nil
  end

  it 'catches missing components' do
    message.delete 'components'
    expect( validate(message) ).not.to be_nil
  end

  it 'catches empty components' do
    message['components'] = []
    expect( validate(message) ).not.to be_nil
  end

  it 'catches malformed component item' do
    message['components'] = ['detectors/radar/1']
    expect( validate(message) ).not.to be_nil
  end

  it 'catches missing component id' do
    message['components'].first.delete 'id'
    expect( validate(message) ).not.to be_nil
  end

  it 'catches missing component type' do
    message['components'].first.delete 'type'
    expect( validate(message) ).not.to be_nil
  end

  it 'catches missing component name' do
    message['components'].first.delete 'name'
    expect( validate(message) ).not.to be_nil
  end

  it 'catches extra component attributes' do
    message['components'].first['extra'] = true
    expect( validate(message) ).not.to be_nil
  end


  it 'catches invalid component type' do
    message['components'].first['type'] = 'tlc sg'
    expect( validate(message) ).not.to be_nil
  end

  it 'catches invalid component name' do
    message['components'].first['name'] = "Signal\nGroup"
    expect( validate(message) ).not.to be_nil
  end

  it 'catches duplicate component entries' do
    message['components'] << message['components'].first.dup
    expect( validate(message) ).not.to be_nil
  end
end
