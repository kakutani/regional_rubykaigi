class AdminController < ApplicationController
  before_filter :login_required
  before_filter :admin_required

  layout "admin"

  private
  def admin_required
    unless current_user && current_user.admin?
      @message = '403 Forbidden'
      render :template => "shared/error.html.erb", :status => 403
    end
  end

end
