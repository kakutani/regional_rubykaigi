# -*- coding: utf-8 -*-
class Admin::EventsController < AdminController
  def index
    @events = Event.find(:all)

    respond_to do |format|
      format.html
    end
  end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @event = Event.new
    @event.capacity = 0
    respond_to do |format|
      format.html
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(:action => 'index')}
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(:action => 'index') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(:action => 'index') }
    end
  end

  def preview
    @event = Event.new(params[:event])
    render :partial => "events/event_desc", :locals => { :event => @event }
  end
end
