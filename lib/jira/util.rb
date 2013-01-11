module JIRA
  module Util
    @fieldmappings = nil

    def get_custom_field(client, fieldname)
      unless @fieldmappings
        call = '/rest/api/2/field'
        @fieldmappings = JSON::parse client.get(call).body
      end

      field = @fieldmappings.select {|prop| prop['name'] == fieldname}
      if field
        field[0]['id']
      else
        nil
      end
    end
  end
end
