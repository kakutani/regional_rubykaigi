require 'hiki_doc'

module ApplicationHelper
  def page_title
    global_title  = "Regional RubyKaigi"
    return global_title unless @page_title
    "#{@page_title} - #{global_title}"
  end

  def render_hiki(text)
    hikified = HikiDoc.to_html(text, :level => 3, :use_wiki_name => false, :allow_bracket_inline_image => false)
    hikified
  end

  def link_to_hikidoc
    link_to('HikiDoc', "http://projects.netlab.jp/hikidoc/?TextFormattingRules.ja")
  end
end
