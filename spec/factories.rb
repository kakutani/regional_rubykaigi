# -*- coding: utf-8 -*-
Factory.define :tokyo01, :class => Event do |e|
  e.name 'tokyo01'
  e.title '東京Ruby会議01'
  e.contact_email "tokyo01@rubykaigi.org"
  e.start_on Date.parse("2008-08-20")
  e.end_on Date.parse("2008-08-20")
  e.capacity 100
  e.publish_at DateTime.parse("2008-08-13 12:00:00")
end

Factory.define :kansai01, :class => Event do |e|
  e.name 'kansai01'
  e.start_on Date.parse('2008-11-07')
  e.end_on Date.parse('2008-11-08')
end
