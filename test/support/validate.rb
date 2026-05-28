# Helper for validating schema files

require 'json_schemer'
require 'pathname'

SCHEMA = JSONSchemer.schema(
  Pathname.new(File.expand_path('../../schema/rsmp.json', __dir__))
)

def validate(message)
  errors = SCHEMA.validate(message).map { |e| [e['data_pointer'], e['type'], e['details']].compact }
  errors.empty? ? nil : errors
end
