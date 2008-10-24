# -*- coding: utf-8 -*-
class Event < ActiveRecord::Base
  has_many :attendees

  named_scope :upcomings, lambda {
    {:conditions => ["force_disabled = ? and start_on >= ?",
        false, Date.today],
      :order => "start_on DESC"}
  }
  named_scope :archives, lambda {
    {:conditions => ["force_disabled = ? and publish_at <= ? and end_on < ?",
        false, DateTime.now, Date.today],
     :order => "end_on"}
  }

  validates_uniqueness_of :name
  validates_format_of :name, :with => /[a-z]+\d+/, :message => "は、開催場所アルファベット名に数字を加えたもの(例:tokyo01)にしてください。"
  validates_presence_of :name, :title, :start_on, :end_on
#  validates_presence_of :contact_email, :official_tag
  validates_numericality_of :capacity, :only_integer => true

  def registration_enabled?
    under_capacity? && !expired?
  end

  def under_capacity?
    attendees_count < capacity
  end

  def expired?
    end_on < Date.today
  end

  def published?
    publish_at <= DateTime.now
  end

  def single_day?
    start_on == end_on
  end

  private
  def attendees_count
    attendees.count
  end
end
