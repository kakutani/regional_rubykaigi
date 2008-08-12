class AdminController < ApplicationController
  before_filter :authentication

  private
  def authentication
    authenticate_or_request_with_http_basic do |user, pass|
      user == 'regional2008' && pass == 'rubykaigi'
    end
  end

end
