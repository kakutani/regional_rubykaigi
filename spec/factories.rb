# -*- coding: utf-8 -*-
Factory.define :tokyo01, :class => Event do |e|
  e.name 'tokyo01'
  e.title '東京Ruby会議01'
  e.capacity 100
  e.scheduled_on Date.parse("2008-08-20")
  e.publish_at DateTime.parse("2008-08-13 12:00:00")
end
