require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Attendee do
  before(:each) do
    @attendee = Attendee.new
  end

  it "should_not be valid" do
    @attendee.should_not be_valid
  end
end
