require 'spec_helper'

describe JIRA::Resource::Story do

  let(:client) { mock() }

  it "should find a story" do
    response = mock()
    response.stub(:body).and_return('{"key":"foo","id":"101"}')
    JIRA::Resource::Story.stub(:collection_path).and_return('/jira/rest/api/2/issue')
    client.should_receive(:get).with('/jira/rest/api/2/issue/foo').
        and_return(response)
    client.should_receive(:get).with('/jira/rest/api/2/issue/101').
        and_return(response)

    issue_from_id = JIRA::Resource::Story.find(client,101)
    issue_from_key = JIRA::Resource::Story.find(client,'foo')

    issue_from_id.attrs.should == issue_from_key.attrs
  end

  it "should have an epic link" do
    JIRA::Resource::Story.stub(:collection_path).and_return('/jira/rest/api/2/issue')
    response = mock()
    response.stub(:body).and_return('{"key":"foo","id":"101"}')
    fields_response = mock()
    fields_response.stub(:body).and_return('[{"id":"dada","name":"Epic Link"}]')
    client.should_receive(:get).with('/rest/api/2/field').
        and_return(fields_response)
    client.should_receive(:get).with('/jira/rest/api/2/issue/101').
        and_return(response)

    issue_from_id = JIRA::Resource::Story.find(client,101)
    issue_from_id.stub(:fields).and_return({'dada' => 'epic-101'})

    issue_from_id.epic.should == 'epic-101'
  end

  it "should save epic links" do
    JIRA::Resource::Story.stub(:collection_path).and_return('/jira/rest/api/2/issue')
    response = mock()
    response.stub(:body).and_return('{"key":"foo","id":"101"}')
    fields_response = mock()
    fields_response.stub(:body).and_return('[{"id":"dada","name":"Epic Link"}]')
    client.should_receive(:get).with('/rest/api/2/field').
        and_return(fields_response)
    client.should_receive(:get).with('/jira/rest/api/2/issue/101').
        and_return(response)

    issue_from_id = JIRA::Resource::Story.find(client,101)
    issue_from_id.stub(:fields).and_return({'dada' => 'epic-101'})

    issue_from_id.epic.should == 'epic-101'

    client.should_receive(:put).with('/rest/greenhopper/1.0/epics/epic-102/add', '{"ignoreEpics":true,"issueKeys":["101"]}')
    issue_from_id.epic = 'epic-102'

    issue_from_id.stub(:fields).and_return({'dada' => 'epic-102'})

    issue_from_id.epic.should == 'epic-102'
  end

end
