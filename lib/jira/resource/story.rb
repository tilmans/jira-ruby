require 'cgi'

module JIRA
  module Resource

    class StoryFactory < JIRA::Resource::IssueFactory # :nodoc:
    end

    class Story < JIRA::Resource::Issue
      include JIRA::Util

      def self.endpoint_name
        'issue'
      end

      def epic
        epic_field = get_custom_field(@client, 'Epic Link')
        unless epic_field
          puts 'Not configured for Greenhopper: No Epic Link field found.'
          return
        end
        fields[epic_field]
      end

      def epic=(epic_link)
        epic_field = get_custom_field(@client, 'Epic Link')
        unless epic_field
          puts 'Not configured for Greenhopper: No Epic Link field found.'
          return
        end
        call = "/rest/greenhopper/1.0/epics/#{epic_link}/add"
        body = {"ignoreEpics" => true, "issueKeys" => [id]}.to_json
        $client.put(call,body)
      end
    end
  end
end

