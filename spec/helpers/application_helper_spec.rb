require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper, "#page_title" do
  include ApplicationHelper
  describe 'default' do
    it "should have site name only" do
      page_title.should == "Regional RubyKaigi"
    end
  end

  describe 'w/ page title' do
    before do
      @title = "PageTitle"
    end
    it "should have page title and site name" do
      page_title.should == "PageTitle - Regional RubyKaigi"
    end
  end
end

describe ApplicationHelper, "#render_hiki" do
  include ApplicationHelper

  it "should render hikified html" do
    render_hiki(<<-HIKI).should == <<-HTML
!this is header1, but rendered as h3.
* hello, world
    HIKI
<h3>this is header1, but rendered as h3.</h3>
<ul>
<li>hello, world</li>
</ul>
    HTML
  end
end
