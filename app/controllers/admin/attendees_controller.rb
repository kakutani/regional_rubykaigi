class Admin::AttendeesController < ApplicationController
  before_filter :fetch_event_with_attendees

  def fetch_event_with_attendees
    @event = Event.find(params[:event_id], :include => :attendees, :order => "attendees.name")
  end

  def index
    @attendees = @event.attendees
  end

  def destroy
    @attendee = Attendee.find(params[:id])
    @attendee.destroy
    redirect_to :action => 'index'
  end
end
