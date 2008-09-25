# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Attendee do
  before(:each) do
    @attendee = Attendee.new
  end

  it "should_not be valid" do
    @attendee.should_not be_valid
  end
end

describe Attendee do
  before do
    Attendee.delete(:all)
    alice_attended_past_event = Attendee.create(:event_id => 1, :email => 'alice@example.com', :name => 'Alice')
    @alice = Attendee.new(:event_id => 2, :email => 'alice@example.com', :name => 'Alice')
  end

  it "参加者は同一メールアドレスで他のイベントに参加できること" do
    @alice.should be_valid
  end

end
