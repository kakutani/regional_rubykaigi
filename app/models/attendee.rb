class Attendee < ActiveRecord::Base
  belongs_to :event

  validates_presence_of :name, :email
  validates_uniqueness_of :email, :scope => :event_id
end
