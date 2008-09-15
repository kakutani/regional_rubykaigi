# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  protect_from_forgery :except => :create

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    open_id_authentication
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end

  # TODO delete. we don't use password login
#   def password_authentication(params)
#     user = User.authenticate(params[:login], params[:password])
#     if user
#       # Protects against session fixation attacks, causes request forgery
#       # protection if user resubmits an earlier form using back
#       # button. Uncomment if you understand the tradeoffs.
#       # reset_session
#       self.current_user = user
#       new_cookie_flag = (params[:remember_me] == "1")
#       handle_remember_cookie! new_cookie_flag
#       redirect_back_or_default('/')
#       flash[:notice] = _("Logged in successfully")
#     else
#       note_failed_signin
#       @login       = params[:login]
#       @remember_me = params[:remember_me]
#       render :action => 'new'
#     end
#   end

  def open_id_authentication
    user = nil
    authenticate_with_open_id do |result, identity_url|
      if result.successful?
        user = (User.find_by_identity_url(identity_url) rescue nil)
        if user
          self.current_user = user
          redirect_back_or_default('/')
          flash[:notice] = _("Logged in successfully")
        else
          # XXX this case is login was succeeded but doesn't any account available.
          # TODO user not found case
          # FIXME integrate to note_failed_signin
          flash[:error] = "Couldn't log you in as '#{identity_url}'"
          logger.warn "Failed login w/ openid for '#{identity_url}' from #{request.remote_ip} at #{Time.now.utc}, message: #{result.message}"
          @openid_identifier = params[:openid_identifier]
          redirect_back_or_default('/')
        end
      else
        # FIXME integrate to note_failed_signin
        flash[:error] = "Couldn't log you in as '#{identity_url}'"
        logger.warn "Failed login w/ openid for '#{identity_url}' from #{request.remote_ip} at #{Time.now.utc}, message: #{result.message}"
        @openid_identifier = params[:openid_identifier]
        redirect_back_or_default('/')
      end
    end
  end
end
