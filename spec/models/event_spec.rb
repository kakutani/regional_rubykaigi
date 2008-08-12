require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  before(:each) do
    @event = Event.new
  end

  it "should be valid" do
    @event.should be_valid
  end
end

describe Event, "#under_capacity?" do
  before do
    @event = Event.new(:capacity => 10)
  end

  describe "when enabled" do
    before do
      @event.stub!(:attendees_count).and_return(9)
    end

    it { @event.should be_under_capacity }
  end

  describe "when equal" do
    before do
      @event.stub!(:attendees_count).and_return(10)
    end

    it { @event.should_not be_under_capacity }
  end
end

describe Event, "#expired?" do
  before do
    @event = Event.new(:scheduled_on => Date.parse("2008-08-01"))
  end

  describe "when the day before" do
    before do
      Date.stub!(:today).and_return(Date.parse("2008-07-31"))
    end

    it { @event.should_not be_expired }
  end

  describe "when the day" do
    before do
      Date.stub!(:today).and_return(Date.parse("2008-08-01"))
    end

    it { @event.should_not be_expired }
  end

  describe "when the day after" do
    before do
      Date.stub!(:today).and_return(Date.parse("2008-08-02"))
    end

    it { @event.should be_expired }
  end

end
