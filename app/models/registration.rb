# -*- coding: utf-8 -*-
class Registration < ActionMailer::Base

  def message(attendee)
    event = attendee.event
    subject "[#{event.title}]登録完了のおしらせ"
    recipients attendee.email
    from event.contact_email
    bcc (::MAIL_CONF[:bcc] || event.contact_email)
    sent_on    Time.now
    body :event => event, :attendee => attendee
  end

end
