class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :case_sensitive => false
  validates_format_of       :login,    :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD

  validates_presence_of :identity_url
  validates_uniqueness_of :identity_url, :case_sensitive => false

  attr_accessible :login, :identity_url
end
