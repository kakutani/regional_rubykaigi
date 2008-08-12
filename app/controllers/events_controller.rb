# -*- coding: utf-8 -*-
class EventsController < ApplicationController
  before_filter :fetch_event
  before_filter :check_registration_enabled, :except => [:index, :show]

  def fetch_event
    @event = Event.find_by_name(params[:name])
  end

  def check_registration_enabled
    unless @event.registration_enabled?
      redirect_to :action => 'show', :name => @event.name
    end
  end

  verify :method => :post, :only => :register, :redirect_to => {:action => "index"}
  def index
#    @events = Event.find(:all, :order => "scheduled_on DESC")
    redirect_to :action => 'show', :name => 'tokyo01'
  end

  def show
    @page_title = @event.title
  end

  def registration
    @attendee = Attendee.new
  end

  def register
    @attendee = Attendee.new(params[:attendee])
    @attendee.remote_ip = request.remote_ip
    @attendee.event = @event
    if @attendee.save
      if @event.notify_email_enabled?
        Registration.deliver_message(@attendee)
      end
      redirect_to :action => 'done', :name => 'tokyo01'
    else
      render :action => 'registration'
    end
  end
end
