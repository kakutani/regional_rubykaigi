# -*- coding: utf-8 -*-
module EventsHelper
  def render_registration_link
      content_tag :div, :class => "registration_link" do
      if @event.registration_enabled?
        link_to('フォームから参加登録をする', :action => 'registration')
      else
        message_for_retgistration_is_closed
      end
    end
  end

  def message_for_retgistration_is_closed
    content_tag :span, :class => "closed" do
      "参加登録の受付は終了しました"
    end
  end
end
