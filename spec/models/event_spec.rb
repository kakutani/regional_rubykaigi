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

describe Event, "#published?" do
  before do
    @event = Event.new(:publish_at => DateTime.parse("2008-09-17 12:00:00"))
  end

  describe "when tha datetime before" do
    before do
      DateTime.stub!(:now).and_return(DateTime.parse("2008-09-16 00:00:00"))
    end

    it { @event.should_not be_published }
  end

  describe "when the datetime" do
    before do
      DateTime.stub!(:now).and_return(DateTime.parse("2008-09-17 12:00:00"))
    end

    it { @event.should be_published }
  end

  describe "when the datetime after" do
    before do
      DateTime.stub!(:now).and_return(DateTime.parse("2008-09-17 12:00:01"))
    end

    it { @event.should be_published }
  end
end

describe Event, "for toppage" do
  before(:all) do
    Event.delete_all

    Event.create(:name => 'rubykaigi2008', :scheduled_on => Date.parse("2008-06-20"),
      :publish_at => DateTime.parse("2008-03-01 12:00:00"))

    Event.create(:name => 'tokyo01', :scheduled_on => Date.parse("2008-08-20"),
      :publish_at => DateTime.parse("2008-08-13 12:00:00"))

    Event.create(:name => 'sapporo01', :scheduled_on => Date.parse("2008-10-25"),
      :publish_at => DateTime.parse("2008-09-16 12:00:00"))

    Event.create(:name => 'matsue01', :scheduled_on => Date.parse("2008-10-18"),
      :publish_at => DateTime.parse("2008-09-10 12:00:00"))

    Event.create(:name => 'kyushu01', :scheduled_on => Date.parse("2008-12-14"),
      :publish_at => DateTime.parse("2008-11-30 12:00:00"))
  end

  before(:each) do
    Date.stub!(:today).and_return(Date.parse("2008-09-17"))
    DateTime.stub!(:now).and_return(DateTime.parse("2008-09-17 15:00:00"))
  end

  it { Event.should have(5).records }

  describe "upcomings" do
    before do
      @upcomings = Event.upcomings
    end

    it { @upcomings.size.should == 2 }
    it { @upcomings[0].name == "matsue01" }
    it { @upcomings[1].name == "sapporo01" }
  end

  describe "archives" do
    before do
      @archives = Event.archives
    end

    it { @archives.size.should == 2 }
    it { @archives[0].name.should == "rubykaigi2008" }
    it { @archives[1].name.should == "tokyo01" }
  end
end
