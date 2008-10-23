require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsHelper do
  include EventsHelper

  describe "when builtin registration" do
    before do
      @event = Factory.build(:tokyo01, :use_builtin_registration => true)
    end

    it "should render registration_external" do
      render_registration_link.should have_tag("div.registration_link")
    end
  end

  describe "when external registration" do
    before do
      @event = Factory.build(:tokyo01, :use_builtin_registration => false)
    end

    it "should render registration_external" do
      self.should_receive(:render_hiki).and_return("content")
      render_registration_link.should have_tag("div.registration_external")
    end
  end
end
