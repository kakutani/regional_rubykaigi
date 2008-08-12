class Attendee < ActiveRecord::Base
  belongs_to :event

  validates_presence_of :name
  validates_uniqueness_of :email
end
