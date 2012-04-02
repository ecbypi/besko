require 'spec_helper'

describe NavigationHelper do
  let(:paths) { [['Name', '/path']] }

  describe "#list_items" do
    it "turns an array of arrays into an array of list items containing anchor tags" do
      list_items = helper.list_items(paths)
      list_items.should match '<a href="/path">Name</a>'
      list_items.should match /^<li/
      list_items.should match /<\/a><\/li>$/
    end

    it "adds the class of 'active' if the request path equals the current path" do
      allow_message_expectations_on_nil
      helper.stub(:request).stub(:path).and_return('/path')
      request.stub(:path).and_return('/path')
      list_items = helper.list_items(paths)

      list_items.should match /active/
    end

    it "allows passing in additional options accepted by content_tag" do
      list_items = helper.list_items(paths, data: { passed: true })
      list_items.should match 'data-passed'
    end
  end

  describe "#navigation" do
    before :each do
      helper.stub(:navigation_paths).and_return(paths)
      helper.stub(:sub_paths).and_return([[]])
    end

    it "builds primary navigation list items" do
      helper.navigation.should match /^<li[^>]*><a href="\/path">Name<\/a><\/li>/
    end

    it "adds a section class to list items" do
      helper.navigation.should match /<li class=".*section.*"/
    end

    it "includes a nav.sub element if sub-paths exist for that section" do
      helper.stub(:sub_paths).and_return([[['Sub Name', '/sub/path']]])
      helper.navigation.should match /<nav class="sub"><ul><li[^>]*><a href="\/sub\/path">Sub Name<\/a><\/li><\/ul><\/nav>/
    end
  end
end
