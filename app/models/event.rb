class Event < ActiveRecord::Base
  has_many :attendees

  def registration_enabled?
    under_capacity? && !expired?
  end

  def under_capacity?
    attendees_count < capacity
  end

  def expired?
    scheduled_on < Date.today
  end

  private
  def attendees_count
    attendees.count
  end
end
